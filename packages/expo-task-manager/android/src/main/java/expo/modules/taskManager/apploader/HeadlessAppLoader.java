package expo.modules.taskManager.apploader;

import android.content.Context;
import android.util.Log;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactInstanceManager;

public class HeadlessAppLoader {

    private Context mContext;

    public HeadlessAppLoader(Context context) {
        this.mContext = context;
    }

    public void loadApp() {

        ReactInstanceManager reactInstanceManager = ((ReactApplication) mContext.getApplicationContext()).getReactNativeHost().getReactInstanceManager();
        if (!isReactInstanceRunning(reactInstanceManager)) {
            reactInstanceManager.addReactInstanceEventListener(context -> {
                Log.d("REACT", "Instance initialized");
                reactInstanceManager.getPackages();
            });
            reactInstanceManager.createReactContextInBackground();
        }
    }

    private boolean isReactInstanceRunning(ReactInstanceManager reactInstanceManager) {
        return reactInstanceManager.hasStartedCreatingInitialContext();
    }
}
