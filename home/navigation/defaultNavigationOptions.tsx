import { StackNavigationOptions, HeaderStyleInterpolators } from '@react-navigation/stack';
import { Platform, StyleSheet } from 'react-native';

import Colors, { ColorTheme } from '../constants/Colors';

export default (theme: ColorTheme): StackNavigationOptions => {
  return {
    headerStyle: {
      borderBottomColor: Colors[theme].cardSeparator,
      elevation: 0,
      backgroundColor: Colors[theme].navBackgroundColor,
      borderBottomWidth: StyleSheet.hairlineWidth,
    },
    headerTitleStyle: {
      fontWeight: Platform.OS === 'ios' ? '600' : '400',
      color: Colors[theme].text,
    },
    headerStyleInterpolator: HeaderStyleInterpolators.forUIKit,
  };
};
