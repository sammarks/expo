package expo.modules.updates.manifest.raw

import androidx.test.internal.runner.junit4.AndroidJUnit4ClassRunner
import org.json.JSONObject
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4ClassRunner::class)
class NewRawManifestTest {
  @Test
  @Throws(Exception::class)
  fun testGetSDKVersionNullable_ValidCases() {
    val runtimeVersion = "exposdk:39.0.0"
    val manifestJson =
      "{\"runtimeVersion\":\"$runtimeVersion\"}"
    val manifest = NewRawManifest(JSONObject(manifestJson))
    Assert.assertEquals(manifest.getSDKVersionNullable(), "39.0.0")
  }

  @Test
  @Throws(Exception::class)
  fun testGetSDKVersionNullable_NotSDKRuntimeVersionCases() {
    val runtimeVersions = listOf(
      "exposdk:123",
      "exposdkd:39.0.0",
      "exposdk:hello",
      "bexposdk:39.0.0",
      "exposdk:39.0.0-beta.0",
      "exposdk:39.0.0-alpha.256"
    )
    runtimeVersions.forEach { runtimeVersion ->
      val manifestJson =
        "{\"runtimeVersion\":\"$runtimeVersion\"}"
      val manifest = NewRawManifest(JSONObject(manifestJson))
      Assert.assertNull(manifest.getSDKVersionNullable())
    }
  }
}
