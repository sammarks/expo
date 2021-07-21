#import "ABI40_0_0REAValueNode.h"

@interface ABI40_0_0REAParamNode : ABI40_0_0REAValueNode

- (void)beginContext:(NSNumber*) ref
          prevCallID:(NSNumber*) prevCallID;
- (void)endContext;
- (void)start;
- (void)stop;
- (BOOL)isRunning;
@end

