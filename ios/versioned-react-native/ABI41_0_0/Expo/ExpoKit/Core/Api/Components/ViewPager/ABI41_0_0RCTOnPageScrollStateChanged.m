#import <ABI41_0_0React/ABI41_0_0UIView+React.h>
#import "ABI41_0_0RCTOnPageScrollStateChanged.h"

@implementation ABI41_0_0RCTOnPageScrollStateChanged
{
    NSString* _state;
    uint16_t _coalescingKey;
}

@synthesize viewTag = _viewTag;

- (NSString *)eventName {
    return @"onPageScrollStateChanged";
}

- (instancetype) initWithABI41_0_0ReactTag:(NSNumber *)ABI41_0_0ReactTag
                            state:(NSString *)state
                    coalescingKey:(uint16_t)coalescingKey;
{
    ABI41_0_0RCTAssertParam(ABI41_0_0ReactTag);
    
    if ((self = [super init])) {
        _viewTag = ABI41_0_0ReactTag;
        _state = state;
        _coalescingKey = coalescingKey;
    }
    return self;
}

ABI41_0_0RCT_NOT_IMPLEMENTED(- (instancetype)init)
- (uint16_t)coalescingKey
{
    return _coalescingKey;
}


- (BOOL)canCoalesce
{
    return NO;
}

+ (NSString *)moduleDotMethod
{
    return @"ABI41_0_0RCTEventEmitter.receiveEvent";
}

- (NSArray *)arguments
{
    return @[self.viewTag, ABI41_0_0RCTNormalizeInputEventName(self.eventName), @{
                 @"pageScrollState": _state,
                 }];
}

- (id<ABI41_0_0RCTEvent>)coalesceWithEvent:(id<ABI41_0_0RCTEvent>)newEvent;
{
    return newEvent;
}

@end
