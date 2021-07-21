import { Command } from '@expo/commander';
import chalk from 'chalk';
import fs from 'fs-extra';
import inquirer from 'inquirer';
import os from 'os';
import path from 'path';

import { EXPO_DIR } from '../Constants';
import { GitDirectory } from '../Git';
import logger from '../Logger';
import { PackageJson } from '../Packages';
import { updateBundledVersionsAsync } from '../ProjectVersions';
import * as Workspace from '../Workspace';
import {
  getVendoringAvailablePlatforms,
  listAvailableVendoredModulesAsync,
  vendorPlatformAsync,
} from '../vendoring';
import vendoredModulesConfig from '../vendoring/config';
import { legacyVendorModuleAsync } from '../vendoring/legacy';
import { VendoringTargetConfig } from '../vendoring/types';

type ActionOptions = {
  list: boolean;
  listOutdated: boolean;
  target: string;
  module: string;
  platform: string;
  commit: string;
  semverPrefix: string;
  updateDependencies?: boolean;
};

const EXPO_GO_TARGET = 'expo-go';

export default (program: Command) => {
  program
    .command('update-vendored-module')
    .alias('update-module', 'uvm')
    .description('Updates 3rd party modules.')
    .option('-l, --list', 'Shows a list of available 3rd party modules.', false)
    .option('-o, --list-outdated', 'Shows a list of outdated 3rd party modules.', false)
    .option(
      '-t, --target <string>',
      'The target to update, e.g. Expo Go or development client.',
      EXPO_GO_TARGET
    )
    .option('-m, --module <string>', 'Name of the module to update.')
    .option(
      '-p, --platform <string>',
      'A platform on which the vendored module will be updated.',
      'all'
    )
    .option(
      '-c, --commit <string>',
      'Git reference on which to checkout when copying 3rd party module.',
      'master'
    )
    .option(
      '-s, --semver-prefix <string>',
      'Setting this flag forces to use given semver prefix. Some modules may specify them by the config, but in case we want to update to alpha/beta versions we should use an empty prefix to be more strict.',
      null
    )
    .option(
      '-u, --update-dependencies',
      'Whether to update workspace dependencies and bundled native modules.',
      true
    )
    .asyncAction(action);
};

async function action(options: ActionOptions) {
  const target = await resolveTargetNameAsync(options.target);
  const targetConfig = vendoredModulesConfig[target];

  if (options.list || options.listOutdated) {
    if (target !== EXPO_GO_TARGET) {
      throw new Error(`Listing vendored modules for target "${target}" is not supported.`);
    }
    await listAvailableVendoredModulesAsync(targetConfig.modules, options.listOutdated);
    return;
  }

  const moduleName = await resolveModuleNameAsync(options.module, targetConfig);
  const sourceDirectory = path.join(os.tmpdir(), 'ExpoVendoredModules', moduleName);
  const moduleConfig = targetConfig.modules[moduleName];

  logger.log(
    '📥 Cloning %s#%s from %s',
    chalk.green(moduleName),
    chalk.cyan(options.commit),
    chalk.magenta(moduleConfig.source)
  );

  try {
    // Clone repository from the source
    await GitDirectory.shallowCloneAsync(
      sourceDirectory,
      moduleConfig.source,
      options.commit ?? 'master'
    );

    const platforms = resolvePlatforms(options.platform);

    for (const platform of platforms) {
      if (!targetConfig.platforms[platform]) {
        continue;
      }

      // TODO(@tsapeta): Remove this once all vendored modules are migrated to the new system.
      if (!targetConfig.modules[moduleName][platform]) {
        // If the target doesn't support this platform, maybe legacy vendoring does.
        logger.info('‼️  Using legacy vendoring for platform %s', chalk.yellow(platform));
        await legacyVendorModuleAsync(moduleName, platform, sourceDirectory);
        continue;
      }

      const relativeTargetDirectory = path.join(
        targetConfig.platforms[platform].targetDirectory,
        moduleName
      );
      const targetDirectory = path.join(EXPO_DIR, relativeTargetDirectory);

      logger.log(
        '🎯 Vendoring for %s to %s',
        chalk.yellow(platform),
        chalk.magenta(relativeTargetDirectory)
      );

      // Clean up previous version
      await fs.remove(targetDirectory);

      // Delegate further steps to platform's provider
      await vendorPlatformAsync(platform, sourceDirectory, targetDirectory, moduleConfig[platform]);
    }

    // Update dependency versions only for Expo Go target.
    if (options.updateDependencies !== false && target === EXPO_GO_TARGET) {
      const packageJson = require(path.join(sourceDirectory, 'package.json')) as PackageJson;
      const semverPrefix =
        (options.semverPrefix != null ? options.semverPrefix : moduleConfig.semverPrefix) || '';
      const newVersionRange = `${semverPrefix}${packageJson.version}`;

      await updateDependenciesAsync(moduleName, newVersionRange);
    }
  } finally {
    // Clean cloned repo
    await fs.remove(sourceDirectory);
  }
  logger.success('💪 Successfully updated %s\n', chalk.bold(moduleName));
}

/**
 * Updates versions in bundled native modules and workspace projects.
 */
async function updateDependenciesAsync(moduleName: string, versionRange: string) {
  logger.log('✍️  Updating bundled native modules');

  await updateBundledVersionsAsync({
    [moduleName]: versionRange,
  });

  logger.log('✍️  Updating workspace dependencies');

  await Workspace.updateDependencyAsync(moduleName, versionRange);
}

/**
 * Validates provided target name or prompts for the valid one.
 */
async function resolveTargetNameAsync(providedTargetName: string): Promise<string> {
  const targets = Object.keys(vendoredModulesConfig);

  if (providedTargetName) {
    if (targets.includes(providedTargetName)) {
      return providedTargetName;
    }
    throw new Error(`Couldn't find config for ${providedTargetName} target.`);
  }
  const { targetName } = await inquirer.prompt([
    {
      type: 'list',
      name: 'targetName',
      prefix: '❔',
      message: 'In which target do you want to update vendored module?',
      choices: targets.map((target) => ({
        name: vendoredModulesConfig[target].name,
        value: target,
      })),
    },
  ]);
  return targetName;
}

/**
 * Validates provided module name or prompts for the valid one.
 */
async function resolveModuleNameAsync(
  providedModuleName: string,
  targetConfig: VendoringTargetConfig
): Promise<string> {
  const moduleNames = Object.keys(targetConfig.modules);

  if (providedModuleName) {
    if (moduleNames.includes(providedModuleName)) {
      return providedModuleName;
    }
    throw new Error(`Couldn't find config for ${providedModuleName} module.`);
  }
  const { moduleName } = await inquirer.prompt([
    {
      type: 'list',
      name: 'moduleName',
      prefix: '❔',
      message: 'Which vendored module do you want to update?',
      choices: moduleNames,
    },
  ]);
  return moduleName;
}

function resolvePlatforms(platform: string): string[] {
  const all = getVendoringAvailablePlatforms();
  return all.includes(platform) ? [platform] : all;
}
