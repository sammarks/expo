// Copyright 2015-present 650 Industries. All rights reserved.

#import <UIKit/UIKit.h>

@protocol ABI40_0_0UMLogHandler

- (void)info:(NSString *)message;
- (void)warn:(NSString *)message;
- (void)error:(NSString *)message;
- (void)fatal:(NSError *)error;

@end
