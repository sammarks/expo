/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI40_0_0React/components/rncore/EventEmitters.h>
#include <ABI40_0_0React/components/rncore/Props.h>
#include <ABI40_0_0React/components/safeareaview/SafeAreaViewState.h>
#include <ABI40_0_0React/components/view/ConcreteViewShadowNode.h>

namespace ABI40_0_0facebook {
namespace ABI40_0_0React {

extern const char SafeAreaViewComponentName[];

/*
 * `ShadowNode` for <SafeAreaView> component.
 */
class SafeAreaViewShadowNode final : public ConcreteViewShadowNode<
                                         SafeAreaViewComponentName,
                                         SafeAreaViewProps,
                                         ViewEventEmitter,
                                         SafeAreaViewState> {
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

 public:
  EdgeInsets alreadyAppliedPadding{};
};

} // namespace ABI40_0_0React
} // namespace ABI40_0_0facebook
