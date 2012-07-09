#import "NSObject+XPCInterop.h"

#import <Foundation/NSString.h>
#import <xpc/xpc.h>

@interface NSString (XPCInterop)

+ (id) stringWithXPCString:(xpc_object_t)xpcString;
- (xpc_object_t) XPCString;

@end
