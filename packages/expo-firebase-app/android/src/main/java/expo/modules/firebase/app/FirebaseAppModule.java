package expo.modules.firebase.app;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import org.unimodules.core.ExportedModule;
import org.unimodules.core.ModuleRegistry;
import org.unimodules.core.Promise;
import org.unimodules.core.interfaces.ActivityProvider;
import org.unimodules.core.interfaces.ExpoMethod;
import org.unimodules.core.interfaces.RegistryLifecycleListener;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;

public class FirebaseAppModule extends ExportedModule implements RegistryLifecycleListener {
    private static final String NAME = "ExpoFirebaseApp";

    protected static final String ERROR_EXCEPTION = "E_FIREBASE_APP";

    static final String DEFAULT_APP_NAME = "[DEFAULT]";

    private Activity mActivity;
    private Context mContext;
    private ModuleRegistry mModuleRegistry;
    private Map<String, String> mDefaultOptions;
    private String mDefaultName;

    public FirebaseAppModule(Context context) {
        super(context);
        mContext = context;
    }

    @Override
    public String getName() {
        return NAME;
    }

    @Override
    public void onCreate(ModuleRegistry moduleRegistry) {
        mModuleRegistry = moduleRegistry;
        ActivityProvider mActivityProvider = moduleRegistry.getModule(ActivityProvider.class);
        mActivity = mActivityProvider.getCurrentActivity();
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();

        if (mDefaultName == null) {
            mDefaultName = getDefaultFirebaseAppName();
        }

        if (mDefaultOptions == null) {
            FirebaseOptions firebaseOptions = getDefaultFirebaseAppOptions();
            mDefaultOptions = FirebaseAppOptions.toJSON(firebaseOptions);
        }

        if (mDefaultName != null) {
            constants.put("DEFAULT_NAME", mDefaultName);
        }

        if (mDefaultOptions != null) {
            constants.put("DEFAULT_OPTIONS", mDefaultOptions);
        }

        return constants;
    }

    String getDefaultFirebaseAppName() {
        FirebaseApp app = FirebaseApp.getInstance();
        return (app != null) ? app.getName() : DEFAULT_APP_NAME;
    }

    FirebaseOptions getDefaultFirebaseAppOptions() {
        FirebaseApp app = FirebaseApp.getInstance();
        // TODO, load from resources?
        return (app != null) ? app.getOptions() : null;
    }

    boolean isFirebaseAppAccessible(final String name) {
        return true;
    }

    private FirebaseApp updateFirebaseApp(final FirebaseOptions options, final String name) {
        FirebaseApp app;
        try {
            app = (name == null) ? FirebaseApp.getInstance() : FirebaseApp.getInstance(name);
        } catch (Exception e) {
            app = null;
        }

        if (app != null) {
            if (options == null) {
                app.delete();
            } else {
                if (!FirebaseAppOptions.isEqual(options, app.getOptions())) {
                    app.delete();
                    if (name == null) {
                        app = FirebaseApp.initializeApp(mActivity.getApplicationContext(), options);
                    } else {
                        app = FirebaseApp.initializeApp(mActivity.getApplicationContext(), options, name);
                    }
                }
            }
        } else {
            if (options != null) {
                if (name == null) {
                    app = FirebaseApp.initializeApp(mActivity.getApplicationContext(), options);
                } else {
                    app = FirebaseApp.initializeApp(mActivity.getApplicationContext(), options, name);
                }
            }
        }

        return app;
    }

    private Bundle getBundleFromApp(final FirebaseApp app) {
        Bundle result = new Bundle();
        result.putString("name", app.getName());

        // Add options
        Map<String, String> optionsJson = FirebaseAppOptions.toJSON(app.getOptions());
        Bundle optionsBundle = new Bundle();
        for (Map.Entry<String, String> entry : optionsJson.entrySet()) {
            optionsBundle.putString(entry.getKey(), entry.getValue());
        }
        result.putBundle("options", optionsBundle);

        return result;
    }

    @ExpoMethod
    public void initializeAppAsync(final Map<String, String> options, String name, Promise promise) {
        try {
            if ((name != null) && (options == null)) {
                promise.reject(ERROR_EXCEPTION, "No options provided for custom app");
                return;
            }
            if (name == null) {
                name = getDefaultFirebaseAppName();
                if (name == null) {
                    promise.reject(ERROR_EXCEPTION, "Failed to determine app name");
                    return;
                }
            }
            if (!isFirebaseAppAccessible(name)) {
                promise.reject(ERROR_EXCEPTION, "Access forbidden to this app");
                return;
            }
            final FirebaseOptions firebaseOptions = (options != null) ? FirebaseAppOptions.fromJSON(options)
                    : getDefaultFirebaseAppOptions();
            FirebaseApp app = this.updateFirebaseApp(firebaseOptions, name);
            promise.resolve(getBundleFromApp(app));
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    private final FirebaseApp getFirebaseAppOrReject(String name, Promise promise) {
        if (name == null) {
            name = getDefaultFirebaseAppName();
        }

        // Check whether access to this app is allowed
        if (!isFirebaseAppAccessible(name)) {
            promise.reject(ERROR_EXCEPTION, "Access forbidden to this app");
            return null;
        }

        // Get app instance
        final FirebaseApp app = FirebaseApp.getInstance(name);
        if (app == null) {
            promise.reject(ERROR_EXCEPTION, "Firebase App not found");
            return null;
        }
        return app;
    }

    @ExpoMethod
    public void deleteAppAsync(final String name, Promise promise) {
        try {
            final FirebaseApp app = getFirebaseAppOrReject(name, promise);
            if (app == null)
                return;
            app.delete();
            promise.resolve(null);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ExpoMethod
    public void getAppAsync(final String name, Promise promise) {
        try {
            final FirebaseApp app = getFirebaseAppOrReject(name, promise);
            if (app == null)
                return;
            promise.resolve(getBundleFromApp(app));
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ExpoMethod
    public void getAppsAsync(Promise promise) {
        try {
            List<FirebaseApp> apps = FirebaseApp.getApps(mActivity.getApplicationContext());
            List<Bundle> bundles = new ArrayList<Bundle>();
            for (FirebaseApp app : apps) {
                if (isFirebaseAppAccessible(app.getName())) {
                    bundles.add(getBundleFromApp(app));
                }
            }
            promise.resolve(bundles);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /*
     * @ExpoMethod public void getAppOptionsAsync(final String name, Promise
     * promise) { try { final FirebaseApp app = getFirebaseAppOrReject(name,
     * promise); if (app == null) return; Map<String, String> json =
     * FirebaseAppOptions.toJSON(app.getOptions()); Bundle response = new Bundle();
     * for (Map.Entry<String, String> entry : json.entrySet()) {
     * response.putString(entry.getKey(), entry.getValue()); }
     * promise.resolve(response); } catch (Exception e) { promise.reject(e); } }
     */
}
