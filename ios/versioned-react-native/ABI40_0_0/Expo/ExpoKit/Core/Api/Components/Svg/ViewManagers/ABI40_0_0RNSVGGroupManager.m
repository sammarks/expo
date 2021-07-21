/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI40_0_0RNSVGGroupManager.h"
#import "ABI40_0_0RNSVGCGFCRule.h"
#import "ABI40_0_0RNSVGGroup.h"

@implementation ABI40_0_0RNSVGGroupManager

ABI40_0_0RCT_EXPORT_MODULE()

- (ABI40_0_0RNSVGNode *)node
{
  return [ABI40_0_0RNSVGGroup new];
}

ABI40_0_0RCT_EXPORT_VIEW_PROPERTY(font, NSDictionary)

ABI40_0_0RCT_CUSTOM_VIEW_PROPERTY(fontSize, id, ABI40_0_0RNSVGGroup)
{
    if ([json isKindOfClass:[NSString class]]) {
        NSString *stringValue = (NSString *)json;
        view.font = @{ @"fontSize": stringValue };
    } else {
        NSNumber* number = (NSNumber*)json;
        double num = [number doubleValue];
        view.font = @{@"fontSize": [NSNumber numberWithDouble:num] };
    }
}

ABI40_0_0RCT_CUSTOM_VIEW_PROPERTY(fontWeight, id, ABI40_0_0RNSVGGroup)
{
    if ([json isKindOfClass:[NSString class]]) {
        NSString *stringValue = (NSString *)json;
        view.font = @{ @"fontWeight": stringValue };
    } else {
        NSNumber* number = (NSNumber*)json;
        double num = [number doubleValue];
        view.font = @{@"fontWeight": [NSNumber numberWithDouble:num] };
    }
}

@end
