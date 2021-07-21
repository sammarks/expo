package abi40_0_0.org.unimodules.adapters.react;

import android.content.Context;

import abi40_0_0.com.facebook.react.bridge.ReactContext;

import java.util.Arrays;
import java.util.List;

import abi40_0_0.org.unimodules.adapters.react.apploader.RNHeadlessAppLoader;
import abi40_0_0.org.unimodules.adapters.react.services.CookieManagerModule;
import abi40_0_0.org.unimodules.adapters.react.services.EventEmitterModule;
import abi40_0_0.org.unimodules.adapters.react.services.FontManagerModule;
import abi40_0_0.org.unimodules.adapters.react.services.RuntimeEnvironmentModule;
import abi40_0_0.org.unimodules.adapters.react.services.UIManagerModuleWrapper;
import abi40_0_0.org.unimodules.core.BasePackage;
import abi40_0_0.org.unimodules.core.interfaces.InternalModule;
import abi40_0_0.org.unimodules.core.interfaces.Package;

import org.unimodules.apploader.AppLoaderProvider;

/**
 * A {@link Package} creating modules provided with the @unimodules/react-native-adapter package.
 */
public class ReactAdapterPackage extends BasePackage {

  @Override
  public List<InternalModule> createInternalModules(Context context) {
    // We can force-cast here, because this package will only be used in React Native context.
    ReactContext reactContext = (ReactContext) context;
    return Arrays.asList(
        new CookieManagerModule(reactContext),
        new UIManagerModuleWrapper(reactContext),
        new EventEmitterModule(reactContext),
        new FontManagerModule(),
        new RuntimeEnvironmentModule()
    );
  }
}
