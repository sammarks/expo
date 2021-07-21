/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI40_0_0React/ABI40_0_0RCTShadowView.h>

@class ABI40_0_0RCTRootShadowView;

@interface ABI40_0_0RCTShadowView (Internal)

@property (nonatomic, weak, readwrite) ABI40_0_0RCTRootShadowView *rootView;

@end
