package abi40_0_0.expo.modules.imageloader

import android.content.Context
import abi40_0_0.org.unimodules.core.BasePackage
import abi40_0_0.org.unimodules.core.interfaces.InternalModule

class ImageLoaderPackage : BasePackage() {
  override fun createInternalModules(context: Context): List<InternalModule> = listOf(ImageLoaderModule(context))
}
