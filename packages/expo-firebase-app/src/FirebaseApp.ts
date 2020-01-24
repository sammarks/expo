import { UnavailabilityError } from '@unimodules/core';
import ExpoFirebaseApp from './ExpoFirebaseApp';
import { FirebaseOptions } from './FirebaseApp.types';
export { FirebaseOptions } from './FirebaseApp.types';
export * from './GoogleServices';

export const { DEFAULT_OPTIONS, DEFAULT_NAME } = ExpoFirebaseApp;

interface FirebaseAppConfig {
  name: string;
  options: FirebaseOptions;
}

class FirebaseApp {
  /**
   * The (read-only) options for this app.
   */
  public name: string;

  /**
   * The (read-only) options for this app.
   */
  public readonly options: FirebaseOptions;

  constructor(config: FirebaseAppConfig) {
    this.name = config.name;
    this.options = config.options;
  }

  get isDefault(): boolean {
    return this.name === DEFAULT_NAME;
  }

  /**
   * Delete the Firebase app instance.
   */
  deleteAsync(): Promise<void> {
    // @ts-ignore
    if (!ExpoFirebaseApp.deleteAppAsync) {
      throw new UnavailabilityError('expo-firebase-app', 'deleteAppAsync');
    }
    // @ts-ignore
    return ExpoFirebaseApp.deleteAppAsync(this._name);
  }

  /**
   * Returns the (read-only) configuration options for this app. These are the original parameters
   * the app was initialized with.
   */
  /*getOptionsAsync(): Promise<FirebaseOptions> {
    // @ts-ignore
    if (!ExpoFirebaseApp.getAppOptionsAsync) {
      throw new UnavailabilityError('expo-firebase-app', 'getAppOptionsAsync');
    }
    // @ts-ignore
    return ExpoFirebaseApp.getAppOptionsAsync(this._name);
  }*/
}

/**
 * Initializes a Firebase app.
 *
 * On iOS and Android this method is optional, as the default Firebase app instance
 * is automatically initialized when the `GoogleService-Info.plist` or `google-services.json`
 * file is configured.
 *
 * You can use this method to initialize additional Firebase app instances. You should typically not
 * initialize the default Firebase with custom options, as the default app is tightly coupled
 * with the google-services config that is shipped with the app.
 */
export async function initializeAppAsync(
  options?: FirebaseOptions,
  name?: string
): Promise<FirebaseApp> {
  // @ts-ignore
  if (!ExpoFirebaseApp.initializeAppAsync) {
    throw new UnavailabilityError('expo-firebase-app', 'initializeAppAsync');
  }
  const result = await ExpoFirebaseApp.initializeAppAsync(options, name);
  return new FirebaseApp(result);
}

/**
 * Retrieves a Firebase app instance.
 * When called with no arguments, the default app is returned. When an app name is provided, the app corresponding to that name is returned.
 * An exception is thrown if the app being retrieved has not yet been initialized.
 *
 * @param name Optional name of the app to return
 */
export async function getAppAsync(name?: string): Promise<FirebaseApp> {
  // @ts-ignore
  if (!ExpoFirebaseApp.getAppAsync) {
    throw new UnavailabilityError('expo-firebase-app', 'getAppAsync');
  }
  const result = await ExpoFirebaseApp.getAppAsync(name);
  return new FirebaseApp(result);
}

/**
 * Retrieves all initialized Firebase app instances.
 */
export async function getAppsAsync(): Promise<FirebaseApp[]> {
  // @ts-ignore
  if (!ExpoFirebaseApp.getAppsAsync) {
    throw new UnavailabilityError('expo-firebase-app', 'getAppsAsync');
  }
  // @ts-ignore
  const results = await ExpoFirebaseApp.getAppsAsync();
  return results.map(result => new FirebaseApp(result));
}
