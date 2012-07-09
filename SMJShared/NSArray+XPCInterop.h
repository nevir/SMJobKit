#import "NSObject+XPCInterop.h"

#import <Foundation/NSArray.h>
#import <xpc/xpc.h>

@interface NSArray (XPCInterop)

+ (id) arrayWithXPCArray:(xpc_object_t)xpcArray;
- (xpc_object_t) XPCArray;

@end
