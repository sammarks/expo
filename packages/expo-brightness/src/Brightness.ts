import { UnavailabilityError } from '@unimodules/core';
import { PermissionResponse, PermissionStatus } from 'expo-modules-core';
import { Platform } from 'react-native';

import ExpoBrightness from './ExpoBrightness';

export enum BrightnessMode {
  UNKNOWN = 0,
  AUTOMATIC = 1,
  MANUAL = 2,
}

export { PermissionResponse, PermissionStatus };

/**
 * Returns whether the Brightness API is enabled on the current device. This does not check the app permissions.
 *
 * @returns Async `boolean`, indicating whether the Brightness API is available on the current device. Currently this resolves `true` on iOS and Android only.
 */
export async function isAvailableAsync(): Promise<boolean> {
  return !!ExpoBrightness.getBrightnessAsync;
}

export async function getBrightnessAsync(): Promise<number> {
  if (!ExpoBrightness.getBrightnessAsync) {
    throw new UnavailabilityError('expo-brightness', 'getBrightnessAsync');
  }
  return await ExpoBrightness.getBrightnessAsync();
}

export async function setBrightnessAsync(brightnessValue: number): Promise<void> {
  if (!ExpoBrightness.setBrightnessAsync) {
    throw new UnavailabilityError('expo-brightness', 'setBrightnessAsync');
  }
  const clampedBrightnessValue = Math.max(0, Math.min(brightnessValue, 1));
  if (isNaN(clampedBrightnessValue)) {
    throw new TypeError(`setBrightnessAsync cannot be called with ${brightnessValue}`);
  }
  return await ExpoBrightness.setBrightnessAsync(clampedBrightnessValue);
}

export async function getSystemBrightnessAsync(): Promise<number> {
  if (Platform.OS !== 'android') {
    return await getBrightnessAsync();
  }
  return await ExpoBrightness.getSystemBrightnessAsync();
}

export async function setSystemBrightnessAsync(brightnessValue: number): Promise<void> {
  const clampedBrightnessValue = Math.max(0, Math.min(brightnessValue, 1));
  if (isNaN(clampedBrightnessValue)) {
    throw new TypeError(`setSystemBrightnessAsync cannot be called with ${brightnessValue}`);
  }
  if (Platform.OS !== 'android') {
    return await setBrightnessAsync(clampedBrightnessValue);
  }
  return await ExpoBrightness.setSystemBrightnessAsync(clampedBrightnessValue);
}

export async function useSystemBrightnessAsync(): Promise<void> {
  if (Platform.OS !== 'android') {
    return;
  }
  // eslint-disable-next-line react-hooks/rules-of-hooks
  return await ExpoBrightness.useSystemBrightnessAsync();
}

export async function isUsingSystemBrightnessAsync(): Promise<boolean> {
  if (Platform.OS !== 'android') {
    return false;
  }
  return await ExpoBrightness.isUsingSystemBrightnessAsync();
}

export async function getSystemBrightnessModeAsync(): Promise<BrightnessMode> {
  if (Platform.OS !== 'android') {
    return BrightnessMode.UNKNOWN;
  }
  return await ExpoBrightness.getSystemBrightnessModeAsync();
}

export async function setSystemBrightnessModeAsync(brightnessMode: BrightnessMode): Promise<void> {
  if (Platform.OS !== 'android' || brightnessMode === BrightnessMode.UNKNOWN) {
    return;
  }
  return await ExpoBrightness.setSystemBrightnessModeAsync(brightnessMode);
}

export async function getPermissionsAsync(): Promise<PermissionResponse> {
  return ExpoBrightness.getPermissionsAsync();
}

export async function requestPermissionsAsync(): Promise<PermissionResponse> {
  return ExpoBrightness.requestPermissionsAsync();
}
