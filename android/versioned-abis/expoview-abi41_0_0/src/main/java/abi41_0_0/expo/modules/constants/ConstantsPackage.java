package abi41_0_0.expo.modules.constants;

import android.content.Context;

import java.util.Collections;
import java.util.List;

import abi41_0_0.org.unimodules.core.ExportedModule;
import abi41_0_0.org.unimodules.core.BasePackage;
import abi41_0_0.org.unimodules.core.interfaces.InternalModule;

public class ConstantsPackage extends BasePackage {
  @Override
  public List<InternalModule> createInternalModules(Context context) {
    return Collections.singletonList((InternalModule) new ConstantsService(context));
  }

  @Override
  public List<ExportedModule> createExportedModules(Context context) {
    return Collections.singletonList((ExportedModule) new ConstantsModule(context));
  }
}
