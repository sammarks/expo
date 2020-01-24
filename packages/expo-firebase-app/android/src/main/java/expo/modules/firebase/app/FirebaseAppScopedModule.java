package expo.modules.firebase.app;

import android.app.Activity;

import android.content.Context;

import org.json.JSONObject;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import org.unimodules.core.ModuleRegistry;
import org.unimodules.core.interfaces.ActivityProvider;
import org.unimodules.interfaces.constants.ConstantsInterface;

import java.util.Map;
import java.util.List;

public class FirebaseAppScopedModule extends FirebaseAppModule {

    private ModuleRegistry mModuleRegistry;

    public FirebaseAppScopedModule(Context context) {
        super(context);
    }

    @Override
    public void onCreate(ModuleRegistry moduleRegistry) {
        super.onCreate(moduleRegistry);

        mModuleRegistry = moduleRegistry;
        ActivityProvider mActivityProvider = moduleRegistry.getModule(ActivityProvider.class);
        Activity activity = mActivityProvider.getCurrentActivity();

        if (!isSandboxed())
            return;

        // On sandboxed environments, delete all running apps, except for the [DEFAULT]
        // app
        // Also, if a `google-services.json` config is available, create that app.

        // TODO - handle possible exceptions here

        // Delete existing apps
        List<FirebaseApp> apps = FirebaseApp.getApps(activity.getApplicationContext());
        for (FirebaseApp app : apps) {
            if (!app.getName().equals(DEFAULT_APP_NAME)) {
                app.delete();
            }
        }

        // Initialize sandboxed app
        String name = getDefaultFirebaseAppName();
        FirebaseOptions options = getDefaultFirebaseAppOptions();
        if ((name != null) && (options != null)) {
            FirebaseApp.initializeApp(activity.getApplicationContext(), options, name);
        }
    }

    // TODO, override getDefaultFirebaseAppName & getDefaultFirebaseOptions
    // in the expo host client?
    private boolean isSandboxed() {
        ConstantsInterface constantsService = mModuleRegistry.getModule(ConstantsInterface.class);
        return constantsService.getAppOwnership().equals("expo");
    }

    @Override
    String getDefaultFirebaseAppName() {
        return isSandboxed() ? "__sandbox.todoExperienceId" : super.getDefaultFirebaseAppName();
    }

    @Override
    FirebaseOptions getDefaultFirebaseAppOptions() {
        return isSandboxed() ? getFirebaseOptionsFromManifest() : super.getDefaultFirebaseAppOptions();
    }

    private FirebaseOptions getFirebaseOptionsFromManifest() {
        ConstantsInterface constantsService = mModuleRegistry.getModule(ConstantsInterface.class);
        Map<String, Object> constants = constantsService.getConstants();
        String manifestString = (String) constants.get("manifest");
        if (manifestString == null)
            return null;
        try {
            JSONObject manifest = new JSONObject(manifestString);
            return FirebaseAppOptions.fromManifest(manifest);
        } catch (Exception err) {
            return null;
        }
    }

    @Override
    boolean isFirebaseAppAccessible(final String name) {
        return isSandboxed() ? !name.equals(DEFAULT_APP_NAME) : super.isFirebaseAppAccessible(name);
    }
}
