---
title: Styling text
---

import SnackInline from '~/components/plugins/SnackInline';
import Highlight from '~/components/plugins/Highlight';

> 👶🏻 We believe in "learning by doing" and so this tutorial emphasizes **doing** over _explaining_. If you find yourself typing code that you do not understand, do not worry &mdash; we will link you to appropriate resources to help you get a deeper understanding at the end of the tutorial.

Let's change the text that's currently instructing us to "Open up App.js to start working on your app!" to instead instruct our users how to use the app. The app doesn't yet do anything but we can pretend that it does, such is the way of programming.

Change your code according to the following example. Throughout the tutorial, any important code or code that has changed between examples will be <Highlight>highlighted in yellow</Highlight>. You can hover over the highlights (on desktop) or tap them (on mobile) to see more context on the change.

<SnackInline label="Updated text">

<!-- prettier-ignore -->
```js
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      /* @info This used to say "Open up App.js to start working on your app!" and now it is slightly more useful. */
      <Text>To share a photo from your phone with a friend, just press the button below!</Text>
    /* @end */
  </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
```

</SnackInline>

<br/>

> 😳 **Wait, what is this "Try this example on Snack" button!?**
>
> Snack is a web-based editor that works similar to a managed Expo project. It's a great way to share code snippets with people and try things out without needing to get a project running on your own computer with `expo-cli`. Go ahead, press the button. You will see the above code running in it. Switch between iOS, Android, or web. Open it on your device in the Expo Go app by pressing the "Run" button.

## Adding style

Our text is black and small. We should change the color because, according to some folks, [you should never use pure black for text or backgrounds](https://uxmovement.com/content/why-you-should-never-use-pure-black-for-text-or-backgrounds/). We'll also increase the font size to make it easier to read.

<SnackInline label="Styled text">

<!-- prettier-ignore -->
```js
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      /* @info Set the style property with color and fontSize. There are many other styles available! Look at them in the <a href="https://reactnative.dev/docs/text#style" target="_blank">React Native Text API reference</a> sometime after you're done with this tutorial. */<Text style={{color: '#888', fontSize: 18}}> /* @end */

        To share a photo from your phone with a friend, just press the button below!
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
```

</SnackInline>

<br/>

> 🎨 **Help, I'm not familiar with any color by the name "#888"!** `#888` is equal parts red, green, and blue, which creates a nice readable grey. React Native uses the same color format as the web, so it supports hex triplets (this is what `#888` is), `rgba`, `hsl`, and a set of named colors like `red`, `green`, `blue`, and, uh, `peru` and `papayawhip`. [Read more about colors in React Native here](https://reactnative.dev/docs/colors).

Good, that looks better! If you want to learn more about the other styles available on the Text component, [you can read more here](https://reactnative.dev/docs/text#style).

Next we're going to look at adding the logo, [let's continue on to looking at the Image component for that](../tutorial/image.md).
