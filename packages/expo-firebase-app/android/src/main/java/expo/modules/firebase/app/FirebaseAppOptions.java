package expo.modules.firebase.app;

import org.json.JSONObject;
import org.json.JSONArray;

import com.google.firebase.FirebaseOptions;

//import com.google.android.gms.common.internal.StringResourceValueReader;

import java.util.Map;
import java.util.HashMap;

class FirebaseAppOptions {

    private static String getJSONStringByPath(JSONObject json, String path) {
        if (json == null)
            return null;
        try {
            String[] paths = path.split("\\.");
            for (int i = 0; i < paths.length; i++) {
                String name = paths[i];
                if (!json.has(name))
                    return null;
                if (i == paths.length - 1) {
                    return json.getString(name);
                } else {
                    json = json.getJSONObject(name);
                }
            }
            return null;
        } catch (Exception err) {
            return null;
        }
    }

    private static void addJSONStringToMap(JSONObject json, Map<String, String> map, String path, String name) {
        String value = getJSONStringByPath(json, path);
        if (value != null)
            map.put(name, value);
    }

    static FirebaseOptions fromManifest(JSONObject manifest) {
        try {
            JSONObject android = manifest.has("android") ? manifest.getJSONObject("android") : null;
            String googleServicesFileString = ((android != null) && android.has("googleServicesFile"))
                    ? android.getString("googleServicesFile")
                    : null;
            JSONObject googleServicesFile = (googleServicesFileString != null)
                    ? new JSONObject(googleServicesFileString)
                    : null;

            // Read project-info settings
            // https://developers.google.com/android/guides/google-services-plugin
            Map<String, String> json = new HashMap<>();
            addJSONStringToMap(googleServicesFile, json, "project_info.project_id", "projectId");
            addJSONStringToMap(googleServicesFile, json, "project_info.project_number", "messagingSenderId");
            addJSONStringToMap(googleServicesFile, json, "project_info.firebase_url", "databaseURL");
            addJSONStringToMap(googleServicesFile, json, "project_info.storage_bucket", "storageBucket");

            // Read client info settings. The client is resolved as follows:
            // 1. Use client with the name "host.exp.exponent" when possible
            // 2. Use first encountered client
            JSONArray clients = googleServicesFile.getJSONArray("client");
            JSONObject client = (clients.length() > 0) ? clients.getJSONObject(0) : null;
            for (int i = 0; i < clients.length(); i++) {
                JSONObject c = clients.getJSONObject(i);
                String packageName = getJSONStringByPath(c, "client_info.android_client_info.package_name");
                if ((packageName != null) && packageName.equals("host.exp.exponent")) {
                    client = c;
                    break;
                }
            }
            addJSONStringToMap(client, json, "client_info.mobilesdk_app_id", "appId");
            addJSONStringToMap(client, json, "services.analytics_service.analytics_property.tracking_id", "trackingId");
            JSONArray apiKey = client.getJSONArray("api_key");
            if ((apiKey != null) && (apiKey.length() > 0)) {
                addJSONStringToMap(apiKey.getJSONObject(0), json, "current_key", "apiKey");
            }

            if (!json.containsKey("appId"))
                return null;
            return fromJSON(json);
        } catch (Exception err) {
            return null;
        }
    }

    static FirebaseOptions fromJSON(final Map<String, String> json) {
        if (json == null)
            return null;
        FirebaseOptions.Builder builder = new FirebaseOptions.Builder();

        if (json.containsKey("apiKey"))
            builder.setApiKey(json.get("apiKey"));
        if (json.containsKey("appId"))
            builder.setApplicationId(json.get("appId"));
        if (json.containsKey("projectId"))
            builder.setProjectId(json.get("projectId"));
        if (json.containsKey("databaseURL"))
            builder.setDatabaseUrl(json.get("databaseURL"));
        if (json.containsKey("storageBucket"))
            builder.setStorageBucket(json.get("storageBucket"));
        if (json.containsKey("messagingSenderId"))
            builder.setGcmSenderId(json.get("messagingSenderId"));
        if (json.containsKey("trackingId"))
            builder.setGaTrackingId(json.get("trackingId"));

        return builder.build();
    }

    static Map<String, String> toJSON(final FirebaseOptions options) {
        if (options == null)
            return null;
        final Map<String, String> result = new HashMap<>();
        result.put("apiKey", options.getApiKey());
        result.put("appId", options.getApplicationId());
        result.put("databaseURL", options.getDatabaseUrl());
        result.put("messagingSenderId", options.getGcmSenderId());
        result.put("projectId", options.getProjectId());
        result.put("storageBucket", options.getStorageBucket());
        result.put("trackingId", options.getGaTrackingId());
        result.put("authDomain", options.getProjectId() + ".firebaseapp.com");

        return result;
    }

    static boolean isEqual(final FirebaseOptions opts1, final FirebaseOptions opts2) {
        if (opts1 == opts2)
            return true;
        if ((opts1 == null) || (opts2 == null))
            return false;
        return opts1.equals(opts2);
    }
}
