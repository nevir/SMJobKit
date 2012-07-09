#import "NSObject+XPCInterop.h"

#import <Foundation/NSValue.h>
#import <xpc/xpc.h>

@interface NSNumber (XPCInterop)

+ (id) numberWithXPCNumber:(xpc_object_t)xpcNumber;
- (xpc_object_t) XPCNumber;

@end
