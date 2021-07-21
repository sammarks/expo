import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { ComponentProps } from 'react';

const BottomTabNavigator = createBottomTabNavigator();
export default BottomTabNavigator;

export const getNavigatorProps = (_props: {
  theme: string;
}): Partial<ComponentProps<typeof BottomTabNavigator.Navigator>> => ({
  tabBarOptions: { labelStyle: { fontWeight: '600' }, keyboardHidesTabBar: false },
});
