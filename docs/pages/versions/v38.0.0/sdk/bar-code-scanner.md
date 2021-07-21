---
title: BarCodeScanner
sourceCodeUrl: 'https://github.com/expo/expo/tree/sdk-38/packages/expo-barcode-scanner'
---

import InstallSection from '~/components/plugins/InstallSection';
import PlatformsSection from '~/components/plugins/PlatformsSection';
import SnackInline from '~/components/plugins/SnackInline';

**`expo-barcode-scanner`** provides a React component that renders a viewfinder for the device's camera (either front or back) and will scan bar codes that show up in the frame.

<PlatformsSection android emulator ios simulator />

> **Note:** Only one active BarCodeScanner preview is supported currently. When using navigation, the best practice is to unmount any previously rendered BarCodeScanner component so the following screens can use `<BarCodeScanner />` without issues.

## Installation

<InstallSection packageName="expo-barcode-scanner" />

## Supported formats

| Bar code format | iOS   | Android     |
| --------------- | ----- | ----------- |
| aztec           | Yes   | Yes         |
| codabar         | No    | Yes         |
| code39          | Yes   | Yes         |
| code93          | Yes   | Yes         |
| code128         | Yes   | Yes         |
| code39mod43     | Yes   | No          |
| datamatrix      | Yes   | Yes         |
| ean13           | Yes   | Yes         |
| ean8            | Yes   | Yes         |
| interleaved2of5 | Yes   | use `itf14` |
| itf14           | Yes\* | Yes         |
| maxicode        | No    | Yes         |
| pdf417          | Yes   | Yes         |
| rss14           | No    | Yes         |
| rssexpanded     | No    | Yes         |
| upc_a           | No    | Yes         |
| upc_e           | Yes   | Yes         |
| upc_ean         | No    | Yes         |
| qr              | Yes   | Yes         |

> Important notes:
>
> - When an ITF-14 barcode is recognized, it's type can sometimes be set to `interleaved2of5`.

> - Scanning for either `PDF417` and/or `Code39` formats can result in a noticable increase in battery consumption on iOS. It is recommended to provide only the bar code formats you expect to scan to the `barCodeTypes` prop.

## Usage

You must request permission to access the user's camera before attempting to get it. To do this, you will want to use the [Permissions](permissions.md) API. You can see this in practice in the following example.

<SnackInline label="Basic BarCodeScanner usage" templateId="bar-code-scanner" dependencies={['expo-barcode-scanner']}>

```js
import React, { useState, useEffect } from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import { BarCodeScanner } from 'expo-barcode-scanner';

export default function App() {
  const [hasPermission, setHasPermission] = useState(null);
  const [scanned, setScanned] = useState(false);

  useEffect(() => {
    (async () => {
      const { status } = await BarCodeScanner.requestPermissionsAsync();
      setHasPermission(status === 'granted');
    })();
  }, []);

  const handleBarCodeScanned = ({ type, data }) => {
    setScanned(true);
    alert(`Bar code with type ${type} and data ${data} has been scanned!`);
  };

  if (hasPermission === null) {
    return <Text>Requesting for camera permission</Text>;
  }
  if (hasPermission === false) {
    return <Text>No access to camera</Text>;
  }

  return (
    <View
      style={{
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'flex-end',
      }}>
      <BarCodeScanner
        onBarCodeScanned={scanned ? undefined : handleBarCodeScanned}
        style={StyleSheet.absoluteFillObject}
      />

      {scanned && <Button title={'Tap to Scan Again'} onPress={() => setScanned(false)} />}
    </View>
  );
}
```

</SnackInline>

## API

```js
import { BarCodeScanner } from 'expo-barcode-scanner';
```

> Note: Passing `undefined` to the `onBarCodeScanned` prop will result in no scanning. This can be used to effectively "pause" the scanner so that it doesn't continually scan even after data has been retrieved.

## Props

- **type (_string_)** -- Camera facing. Use one of `BarCodeScanner.Constants.Type`. Use either `Type.front` or `Type.back`. Same as `Camera.Constants.Type`. Default: `Type.back`.

- **barCodeTypes (_Array\<string\>_)** -- An array of bar code types. Usage: `BarCodeScanner.Constants.BarCodeType.<codeType>` where `codeType` is one of these [listed above](#supported-formats). Defaults to all supported bar code types. It is recommended to provide only the bar code formats you expect to scan to minimize battery usage. For example: `barCodeTypes={[BarCodeScanner.Constants.BarCodeType.qr]}`.

- **onBarCodeScanned (_function_)** -- A callback that is invoked when a bar code has been successfully scanned. The callback is provided with an object of the shape `{ type: BarCodeScanner.Constants.BarCodeType, data: string }`, where the type refers to the bar code type that was scanned and the data is the information encoded in the bar code (in this case of QR codes, this is often a URL).

## Methods

### `BarCodeScanner.scanFromURLAsync(url, barCodeTypes)`

Scan bar codes from the image given by the URL.

#### Arguments

- **url (_string_)** -- URL to get the image from.
- **barCodeTypes (_Array\<BarCodeScanner.Constants.BarCodeType\>_)** -- (as in prop) An array of bar code types. Default: all supported bar code types.
  > Note: Only QR codes are supported on iOS.

#### Returns

A possibly empty array of objects of the shape `{ type: BarCodeScanner.Constants.BarCodeType, data: string }`, where the type refers to the bar code type that was scanned and the data is the information encoded in the bar code.
