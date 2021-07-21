package expo.modules.updates.loader;

import android.content.Context;
import android.net.Uri;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.HashMap;

import androidx.test.internal.runner.junit4.AndroidJUnit4ClassRunner;
import androidx.test.platform.app.InstrumentationRegistry;
import expo.modules.updates.UpdatesConfiguration;
import okhttp3.Request;

@RunWith(AndroidJUnit4ClassRunner.class)
public class FileDownloaderTest {

  private Context context;

  @Before
  public void setup() {
    context = InstrumentationRegistry.getInstrumentation().getTargetContext();
  }

  @Test
  public void testCacheControl_LegacyManifest() {
    HashMap<String, Object> configMap = new HashMap<>();
    configMap.put("updateUrl", Uri.parse("https://exp.host/@test/test"));
    configMap.put("runtimeVersion", "1.0");
    configMap.put("usesLegacyManifest", true);
    UpdatesConfiguration config = new UpdatesConfiguration().loadValuesFromMap(configMap);

    Request actual = FileDownloader.setHeadersForManifestUrl(config, null, context);
    Assert.assertNull(actual.header("Cache-Control"));
  }

  @Test
  public void testCacheControl_NewManifest() {
    HashMap<String, Object> configMap = new HashMap<>();
    configMap.put("updateUrl", Uri.parse("https://exp.host/manifest/00000000-0000-0000-0000-000000000000"));
    configMap.put("runtimeVersion", "1.0");
    configMap.put("usesLegacyManifest", false);
    UpdatesConfiguration config = new UpdatesConfiguration().loadValuesFromMap(configMap);

    Request actual = FileDownloader.setHeadersForManifestUrl(config, null, context);
    Assert.assertNull(actual.header("Cache-Control"));
  }

  @Test
  public void testExtraHeaders_ObjectTypes() throws JSONException {
    HashMap<String, Object> configMap = new HashMap<>();
    configMap.put("updateUrl", Uri.parse("https://exp.host/manifest/00000000-0000-0000-0000-000000000000"));
    configMap.put("runtimeVersion", "1.0");
    UpdatesConfiguration config = new UpdatesConfiguration().loadValuesFromMap(configMap);

    JSONObject extraHeaders = new JSONObject();
    extraHeaders.put("expo-string", "test");
    extraHeaders.put("expo-number", 47.5);
    extraHeaders.put("expo-boolean", true);

    Request actual = FileDownloader.setHeadersForManifestUrl(config, extraHeaders, context);
    Assert.assertEquals("test", actual.header("expo-string"));
    Assert.assertEquals("47.5", actual.header("expo-number"));
    Assert.assertEquals("true", actual.header("expo-boolean"));
  }

  @Test
  public void testExtraHeaders_OverrideOrder() throws JSONException {
    HashMap<String, Object> configMap = new HashMap<>();
    configMap.put("updateUrl", Uri.parse("https://exp.host/manifest/00000000-0000-0000-0000-000000000000"));
    configMap.put("runtimeVersion", "1.0");

    // custom headers configured at build-time should be able to override preset headers
    HashMap<String, String> headersMap = new HashMap<>();
    headersMap.put("expo-updates-environment", "custom");
    configMap.put("requestHeaders", headersMap);
    UpdatesConfiguration config = new UpdatesConfiguration().loadValuesFromMap(configMap);

    // serverDefinedHeaders should not be able to override preset headers
    JSONObject extraHeaders = new JSONObject();
    extraHeaders.put("expo-platform", "ios");

    Request actual = FileDownloader.setHeadersForManifestUrl(config, extraHeaders, context);
    Assert.assertEquals("android", actual.header("expo-platform"));
    Assert.assertEquals("custom", actual.header("expo-updates-environment"));
  }
}
