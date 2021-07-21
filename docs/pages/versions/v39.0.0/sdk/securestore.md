---
title: SecureStore
sourceCodeUrl: 'https://github.com/expo/expo/tree/sdk-39/packages/expo-secure-store'
---

import InstallSection from '~/components/plugins/InstallSection';
import PlatformsSection from '~/components/plugins/PlatformsSection';
import SnackInline from '~/components/plugins/SnackInline';

**`expo-secure-store`** provides a way to encrypt and securely store key–value pairs locally on the device. Each Expo project has a separate storage system and has no access to the storage of other Expo projects. **Please note** that for iOS standalone apps, data stored with `expo-secure-store` can persist across app installs.

iOS: Values are stored using the [keychain services](https://developer.apple.com/documentation/security/keychain_services) as `kSecClassGenericPassword`. iOS has the additional option of being able to set the value's `kSecAttrAccessible` attribute, which controls when the value is available to be fetched.

Android: Values are stored in [`SharedPreferences`](https://developer.android.com/training/basics/data-storage/shared-preferences.html), encrypted with [Android's Keystore system](https://developer.android.com/training/articles/keystore.html).

**Size limit for a value is 2048 bytes. An attempt to store larger values may fail. Currently, we print a warning when the limit is reached, but in a future SDK version, we may throw an error.**

<PlatformsSection android emulator ios simulator />

- This API is not compatible on devices running Android 5 or lower.

## Installation

<InstallSection packageName="expo-secure-store" />

## Usage

<SnackInline label='SecureStore' dependencies={['expo-secure-store']} platforms={['ios', 'android']}>

```jsx
import * as React from 'react';
import { Text, View, StyleSheet, TextInput, Button } from 'react-native';
import * as SecureStore from 'expo-secure-store';

async function save(key, value) {
  await SecureStore.setItemAsync(key, value);
}

async function getValueFor(key) {
  let result = await SecureStore.getItemAsync(key);
  if (result) {
    alert("🔐 Here's your value 🔐 \n" + result);
  } else {
    alert('No values stored under that key.');
  }
}

export default function App() {
  const [key, onChangeKey] = React.useState('Your key here');
  const [value, onChangeValue] = React.useState('Your value here');

  return (
    <View style={styles.container}>
      <Text style={styles.paragraph}>Save an item, and grab it later!</Text>
      {/* @hide Add some TextInput components... */}

      <TextInput
        style={styles.textInput}
        clearTextOnFocus
        onChangeText={text => onChangeKey(text)}
        value={key}
      />
      <TextInput
        style={styles.textInput}
        clearTextOnFocus
        onChangeText={text => onChangeValue(text)}
        value={value}
      />
      {/* @end */}
      <Button
        title="Save this key/value pair"
        onPress={() => {
          save(key, value);
          onChangeKey('Your key here');
          onChangeValue('Your value here');
        }}
      />

      <Text style={styles.paragraph}>🔐 Enter your key 🔐</Text>
      <TextInput
        style={styles.textInput}
        onSubmitEditing={event => {
          getValueFor(event.nativeEvent.text);
        }}
        placeholder="Enter the key for the value you want to get"
      />
    </View>
  );
}

/* @hide const styles = StyleSheet.create({ ... }); */
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    paddingTop: 10,
    backgroundColor: '#ecf0f1',
    padding: 8,
  },
  paragraph: {
    marginTop: 34,
    margin: 24,
    fontSize: 18,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  textInput: {
    height: 35,
    borderColor: 'gray',
    borderWidth: 0.5,
    padding: 4,
  },
});
/* @end */
```

</SnackInline>

## API

```js
import * as SecureStore from 'expo-secure-store';
```

### `SecureStore.isAvailableAsync()`

Returns whether the SecureStore API is enabled on the current device.

#### Returns

Async `boolean`, indicating whether the SecureStore API is available on the current device. Currently this resolves `true` on iOS and Android only.

### `SecureStore.setItemAsync(key, value, options)`

Store a key–value pair.

#### Arguments

- **key (_string_)** -- The key to associate with the stored value. Keys may contain alphanumeric characters `.`, `-`, and `_`.

- **value (_string_)** -- The value to store. Size limit is 2048 bytes.

- **options (_object_)** (optional) -- A map of options:

  - **keychainService (_string_)** --

    - iOS: The item's service, equivalent to `kSecAttrService`
    - Android: Equivalent of the public/private key pair `Alias`

    **NOTE** If the item is set with the `keychainService` option, it will be required to later fetch the value.

  - **keychainAccessible (_enum_)** --
    - iOS only: Specifies when the stored entry is accessible, using iOS's `kSecAttrAccessible` property. See Apple's documentation on [keychain item accessibility](https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/02concepts/concepts.html#//apple_ref/doc/uid/TP30000897-CH204-SW18). The available options are:
      - `SecureStore.WHEN_UNLOCKED` (default): The data in the keychain item can be accessed only while the device is unlocked by the user.
      - `SecureStore.AFTER_FIRST_UNLOCK`: The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user. This may be useful if you need to access the item when the phone is locked.
      - `SecureStore.ALWAYS`: The data in the keychain item can always be accessed regardless of whether the device is locked. This is the least secure option.
      - `SecureStore.WHEN_UNLOCKED_THIS_DEVICE_ONLY`: Similar to `WHEN_UNLOCKED`, except the entry is not migrated to a new device when restoring from a backup.
      - `SecureStore.WHEN_PASSCODE_SET_THIS_DEVICE_ONLY`: Similar to `WHEN_UNLOCKED_THIS_DEVICE_ONLY`, except the user must have set a passcode in order to store an entry. If the user removes their passcode, the entry will be deleted.
      - `SecureStore.AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY`: Similar to `AFTER_FIRST_UNLOCK`, except the entry is not migrated to a new device when restoring from a backup.
      - `SecureStore.ALWAYS_THIS_DEVICE_ONLY`: Similar to `ALWAYS`, except the entry is not migrated to a new device when restoring from a backup.

#### Returns

A promise that will reject if value cannot be stored on the device.

### `SecureStore.getItemAsync(key, options)`

Fetch the stored value associated with the provided key.

#### Arguments

- **key (_string_)** -- The key that was used to store the associated value.

- **options (_object_)** (optional) -- A map of options:

  - **keychainService (_string_)** --
    iOS: The item's service, equivalent to `kSecAttrService`.
    Android: Equivalent of the public/private key pair `Alias`.

  **NOTE** If the item is set with the `keychainService` option, it will be required to later fetch the value.

#### Returns

A promise that resolves to the previously stored value, or null if there is no entry for the given key. The promise will reject if an error occurred while retrieving the value.

### `SecureStore.deleteItemAsync(key, options)`

Delete the value associated with the provided key.

#### Arguments

- **key (_string_)** -- The key that was used to store the associated value.

- **options (_object_)** (optional) -- A map of options:

  - **keychainService (_string_)** -- iOS: The item's service, equivalent to `kSecAttrService`. Android: Equivalent of the public/private key pair `Alias`. If the item is set with a keychainService, it will be required to later fetch the value.

#### Returns

A promise that will reject if the value couldn't be deleted.
