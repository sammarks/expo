package abi41_0_0.expo.modules.splashscreen

import android.content.Context
import expo.modules.splashscreen.singletons.SplashScreen

import abi41_0_0.org.unimodules.core.BasePackage
import abi41_0_0.org.unimodules.core.ExportedModule
import org.unimodules.core.interfaces.SingletonModule

class SplashScreenPackage : BasePackage() {
  override fun createExportedModules(context: Context): List<ExportedModule> {
    return listOf(SplashScreenModule(context))
  }

  override fun createSingletonModules(context: Context?): List<SingletonModule> {
    return listOf(SplashScreen)
  }
}
