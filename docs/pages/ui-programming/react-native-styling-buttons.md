---
title: Styling a React Native button
sidebar_title: Styling buttons
---

import SnackInline from '~/components/plugins/SnackInline';

React Native exports a [`<Button />`](https://reactnative.dev/docs/button) component that exposes the native button element for Android, iOS, and the web. The `<Button />` component accepts `title` and `onPress` props but it does not accept a `style` prop, which makes it hard to customize the style. The closest we can get to styling a `<Button />` exported from React Native is with the `color` prop. Below is an example of two buttons on Android, iOS, and the web. The first button is the default `<Button />` and the second is another default `<Button />` with its `color` prop set to `"red".

![default-button](/static/images/faq-button-style-button.png)

To create a button with a custom style, we can to turn to the [`<Pressable />`](../versions/latest/react-native/pressable/) component.`<Pressable />`lets us fully customize the appearance of a pressable element (like a button), in addition to allowing us to customize its behavior. Here's an example of using`<Pressable />` to create a button component:

<SnackInline>

<!-- prettier-ignore -->
```jsx
import React from 'react';
import { Text, View, StyleSheet, Pressable } from 'react-native';

export default function Button(props) {
  const { onPress, title = 'Save' } = props;
  return (
    <Pressable style={styles.button} onPress={onPress}>
      <Text style={styles.text}>{title}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    paddingHorizontal: 32,
    borderRadius: 4,
    elevation: 3,
    backgroundColor: 'black',
  },
  text: {
    fontSize: 16,
    lineHeight: 21,
    fontWeight: 'bold',
    letterSpacing: 0.25,
    color: 'white',
  },
});
```

</SnackInline>

And here's the result of this code:

<img width="973" src="/static/images/faq-button-style-pressable.png" alt="Custom styled button component using Pressable" />

React Native's `<Button />` component does not accept a `style` prop, and its `color` prop is limited and appears differently across Android, iOS, and the web. With the `<Pressable />` component, we can create custom buttons that fit our app's design. Those styles will also be the same across Android, iOS, and the web, which will give our apps a consistent look on every platform.
