import { Platform } from 'react-native';
import Constants from 'expo-constants';
import * as FirebaseApp from 'expo-firebase-app';

export const name = 'FirebaseApp';

const DEFAULT_APP_NAME = Platform.select({
  ios: '__FIRAPP_DEFAULT',
  android: '[DEFAULT]',
});

const SANDBOX_APP_PREFIX = '__sandbox';

function getTestSuiteFirebaseOptions() {
  if (Platform.OS === 'android') {
    const googleServicesJson = require('../google-services.json');
    return FirebaseApp.getFirebaseOptionsFromAndroidGoogleServicesFile(googleServicesJson);
  } else if (Platform.OS === 'ios') {
    // TODO, load PLIST using babel-loader?
    return {
      clientId: '1082251606918-ktto2c4d3tit64uikmki48j7520qensp.apps.googleusercontent.com',
      apiKey: 'AIzaSyBH7Pa-tgLgL2QK6DgGhKipuDTbKqU6Wlk',
      storageBucket: 'expo-test-suite.appspot.com',
      projectId: 'expo-test-suite',
      appId: '1:1082251606918:ios:f448eb8df0adab41e24a07',
      databaseURL: 'https://expo-test-suite.firebaseio.com',
      messagingSenderId: '1082251606918',
      authDomain: 'expo-test-suite.firebaseapp.com',
    };
  } else {
    throw new Error('Platform not supported');
  }
}

function expectFirebaseOptions(expect, options1, options2) {
  expect(options1.appId).toBe(options2.appId);
  expect(options1.messagingSenderId).toBe(options2.messagingSenderId);
  expect(options1.apiKey).toBe(options2.apiKey);
  expect(options1.projectId).toBe(options2.projectId);
  expect(options1.clientId).toBe(options2.clientId);
  expect(options1.storageBucket).toBe(options2.storageBucket);
  expect(options1.databaseURL).toBe(options2.databaseURL);
  expect(options1.authDomain).toBe(options2.authDomain);
}

export async function test({ describe, xdescribe, it, xit, expect }) {
  const isSandboxed = Constants.appOwnership === 'expo';
  //const describeSandboxed = isSandboxed ? describe : xdescribe;
  const itSandboxed = isSandboxed ? it : xit;

  describe(name, () => {
    /*beforeAll(async () => {
      await FirebaseApp.initializeAppAsync();
    });*/

    /*afterAll(async () => {
      await FirebaseApp.initializeAppAsync();
    });*/

    describe('getAppAsync()', async () => {
      it(`returns the default app`, async () => {
        let error = null;
        try {
          const app = await FirebaseApp.getAppAsync();
          expect(app.isDefault).toBe(true);
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      it(`returns the default app by name its name`, async () => {
        let error = null;
        try {
          const { name } = await FirebaseApp.getAppAsync();
          const app = await FirebaseApp.getAppAsync(name);
          expect(app.name).toBe(name);
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      it(`throws when an invalid app name is specified`, async () => {
        let error = null;
        try {
          await FirebaseApp.getAppAsync('123ThisAppNameCertainlyDoesntExist');
        } catch (e) {
          error = e;
        }
        expect(error).not.toBeNull();
      });
      it(`returns a (non) sandboxed app`, async () => {
        let error = null;
        try {
          const app = await FirebaseApp.getAppAsync();
          if (isSandboxed) {
            expect(app.name.substring(0, SANDBOX_APP_PREFIX.length)).toBe(SANDBOX_APP_PREFIX);
          } else {
            expect(app.name.substring(0, SANDBOX_APP_PREFIX.length)).not.toBe(SANDBOX_APP_PREFIX);
          }
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      it(`allows/disallowes access to the system default app`, async () => {
        let error = null;
        try {
          const app = await FirebaseApp.getAppAsync(DEFAULT_APP_NAME);
          expect(app.name).toBe(DEFAULT_APP_NAME);
        } catch (e) {
          error = e;
        }
        if (isSandboxed) {
          expect(error).not.toBeNull();
        } else {
          expect(error).toBeNull();
        }
      });
    });

    describe('getAppsAsync()', async () => {
      it(`returns 1 firebase app`, async () => {
        let error = null;
        try {
          const apps = await FirebaseApp.getAppsAsync();
          expect(apps.length).toBe(1);
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      it(`returns a (non) sandboxed app`, async () => {
        let error = null;
        try {
          const apps = await FirebaseApp.getAppsAsync();
          expect(apps.length).toBe(1);
          const app = apps[0];
          if (isSandboxed) {
            expect(app.name.substring(0, SANDBOX_APP_PREFIX.length)).toBe(SANDBOX_APP_PREFIX);
          } else {
            expect(app.name.substring(0, SANDBOX_APP_PREFIX.length)).not.toBe(SANDBOX_APP_PREFIX);
          }
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
    });

    /*describe('getAppOptions()', async () => {
      it(`returns valid firebase options`, async () => {
        let error = null;
        try {
          const app = await FirebaseApp.getAppAsync();
          const options = await app.getOptionsAsync();
          expect(options.appId).not.toBeNull();
          expect(options.messagingSenderId).not.toBeNull();
          expect(options.apiKey).not.toBeNull();
          expect(options.projectId).not.toBeNull();
          expect(options.clientId).not.toBeNull();
          expect(options.storageBucket).not.toBeNull();
          expect(options.databaseURL).not.toBeNull();
          expect(options.authDomain).not.toBeNull();
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
    });*/

    describe('DEFAULT_OPTIONS', async () => {
      it(`returns the default firebase options`, async () => {
        let error = null;
        try {
          const { DEFAULT_OPTIONS } = FirebaseApp;
          expect(DEFAULT_OPTIONS.appId).not.toBeNull();
          expect(DEFAULT_OPTIONS.messagingSenderId).not.toBeNull();
          expect(DEFAULT_OPTIONS.apiKey).not.toBeNull();
          expect(DEFAULT_OPTIONS.projectId).not.toBeNull();
          expect(DEFAULT_OPTIONS.clientId).not.toBeNull();
          expect(DEFAULT_OPTIONS.storageBucket).not.toBeNull();
          expect(DEFAULT_OPTIONS.databaseURL).not.toBeNull();
          expect(DEFAULT_OPTIONS.authDomain).not.toBeNull();
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      it(`should be the same as the default firebase app`, async () => {
        let error = null;
        try {
          const { DEFAULT_OPTIONS } = FirebaseApp;
          const app = await FirebaseApp.getAppAsync();
          const { options } = app;
          expectFirebaseOptions(expect, DEFAULT_OPTIONS, options);
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      itSandboxed(`returns the firebase options from the test-suite`, async () => {
        let error = null;
        try {
          const { DEFAULT_OPTIONS } = FirebaseApp;
          expectFirebaseOptions(expect, DEFAULT_OPTIONS, getTestSuiteFirebaseOptions());
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
    });

    /*describe('deleteAsync()', async () => {
      it(`succeeds when app exists`, async () => {
        let error = null;
        try {
          const app = await FirebaseApp.getAppAsync();
          await app.deleteAsync();
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      it(`is not returned by getAppAsync`, async () => {
        let error = null;
        try {
          const app = await FirebaseApp.getAppAsync();
          expect(app).toBeNull();
        } catch (e) {
          error = e;
        }
        expect(error).not.toBeNull();
      });
      it(`is not returned by getAppsAsync`, async () => {
        let error = null;
        try {
          const apps = await FirebaseApp.getAppsAsync();
          expect(apps.length).toBe(0);
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
      it(`fails when app has been deleted`, async () => {
        let error = null;
        await FirebaseApp.initializeAppAsync();
        const app = await FirebaseApp.getAppAsync();
        try {
          await app.deleteAsync();
        } catch (e) {
          error = e;
        }
        expect(error).toBeNull();
      });
    });*/
  });
}
