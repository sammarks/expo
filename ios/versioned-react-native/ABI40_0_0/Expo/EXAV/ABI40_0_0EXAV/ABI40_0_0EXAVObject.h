// Copyright 2017-present 650 Industries. All rights reserved.

typedef NS_OPTIONS(NSUInteger, ABI40_0_0EXAVAudioSessionMode)
{
  // These are enumerated in ascending order of priority.
  // The ABI40_0_0EXAVAudioSessionMode of the current experience (managed by ABI40_0_0EXAV) should be
  // the maximum of the ABI40_0_0EXAVAudioSessionModes required by each of the live ABI40_0_0EXAVObjects.
  ABI40_0_0EXAVAudioSessionModeInactive    = 0,
  ABI40_0_0EXAVAudioSessionModeActiveMuted = 1,
  ABI40_0_0EXAVAudioSessionModeActive      = 2
};

@protocol ABI40_0_0EXAVObject <NSObject> // For ABI40_0_0EXAVPlayerData and ABI40_0_0EXVideoView to interact with the Audio Session properly

- (void)pauseImmediately;

- (ABI40_0_0EXAVAudioSessionMode)getAudioSessionModeRequired; // TODO (clarity): is needsAudioSession a better name?

- (void)appDidForeground;

- (void)appDidBackground;

- (void)handleAudioSessionInterruption:(NSNotification*)notification;

- (void)handleMediaServicesReset:(void (^)(void))finishCallback;

@end
