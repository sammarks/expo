/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI40_0_0RCTSurfaceRootShadowView.h"

#import "ABI40_0_0RCTI18nUtil.h"
#import "ABI40_0_0RCTShadowView+Layout.h"
#import "ABI40_0_0RCTUIManagerUtils.h"

@implementation ABI40_0_0RCTSurfaceRootShadowView {
  CGSize _intrinsicSize;
  BOOL _isRendered;
  BOOL _isLaidOut;
}

- (instancetype)init
{
  if (self = [super init]) {
    self.viewName = @"ABI40_0_0RCTSurfaceRootView";
    _baseDirection = [[ABI40_0_0RCTI18nUtil sharedInstance] isRTL] ? ABI40_0_0YGDirectionRTL : ABI40_0_0YGDirectionLTR;
    _minimumSize = CGSizeZero;
    _maximumSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);

    self.alignSelf = ABI40_0_0YGAlignStretch;
    self.flex = 1;
  }

  return self;
}

- (void)insertABI40_0_0ReactSubview:(ABI40_0_0RCTShadowView *)subview atIndex:(NSInteger)atIndex
{
  [super insertABI40_0_0ReactSubview:subview atIndex:atIndex];
  if (!_isRendered) {
    [_delegate rootShadowViewDidStartRendering:self];
    _isRendered = YES;
  }
}

- (void)layoutWithAffectedShadowViews:(NSHashTable<ABI40_0_0RCTShadowView *> *)affectedShadowViews
{
  NSHashTable<NSString *> *other = [NSHashTable new];

  ABI40_0_0RCTLayoutContext layoutContext = {};
  layoutContext.absolutePosition = CGPointZero;
  layoutContext.affectedShadowViews = affectedShadowViews;
  layoutContext.other = other;

  [self layoutWithMinimumSize:_minimumSize
                  maximumSize:_maximumSize
              layoutDirection:ABI40_0_0RCTUIKitLayoutDirectionFromYogaLayoutDirection(_baseDirection)
                layoutContext:layoutContext];

  self.intrinsicSize = self.layoutMetrics.frame.size;

  if (_isRendered && !_isLaidOut) {
    [_delegate rootShadowViewDidStartLayingOut:self];
    _isLaidOut = YES;
  }
}

- (void)setMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize
{
  if (CGSizeEqualToSize(minimumSize, _minimumSize) && CGSizeEqualToSize(maximumSize, _maximumSize)) {
    return;
  }

  _maximumSize = maximumSize;
  _minimumSize = minimumSize;
}

- (void)setIntrinsicSize:(CGSize)intrinsicSize
{
  if (CGSizeEqualToSize(_intrinsicSize, intrinsicSize)) {
    return;
  }

  _intrinsicSize = intrinsicSize;

  [_delegate rootShadowView:self didChangeIntrinsicSize:intrinsicSize];
}

- (CGSize)intrinsicSize
{
  return _intrinsicSize;
}

@end
