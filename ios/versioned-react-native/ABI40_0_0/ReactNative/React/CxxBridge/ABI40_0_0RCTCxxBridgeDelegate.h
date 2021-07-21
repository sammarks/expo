/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <memory>

#import <ABI40_0_0React/ABI40_0_0RCTBridgeDelegate.h>

namespace ABI40_0_0facebook {
namespace ABI40_0_0React {

class JSExecutorFactory;

}
}

// This is a separate class so non-C++ implementations don't need to
// take a C++ dependency.

@protocol ABI40_0_0RCTCxxBridgeDelegate <ABI40_0_0RCTBridgeDelegate>

/**
 * In the ABI40_0_0RCTCxxBridge, if this method is implemented, return a
 * ExecutorFactory instance which can be used to create the executor.
 * If not implemented, or returns an empty pointer, JSIExecutorFactory
 * will be used with a JSCRuntime.
 */
- (void *)jsExecutorFactoryForBridge:(ABI40_0_0RCTBridge *)bridge;

@end
