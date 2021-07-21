/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI40_0_0ParagraphState.h"

#include <ABI40_0_0React/components/text/conversions.h>
#include <ABI40_0_0React/debug/debugStringConvertibleUtils.h>

namespace ABI40_0_0facebook {
namespace ABI40_0_0React {

#ifdef ANDROID
folly::dynamic ParagraphState::getDynamic() const {
  return toDynamic(*this);
}
#endif

} // namespace ABI40_0_0React
} // namespace ABI40_0_0facebook
