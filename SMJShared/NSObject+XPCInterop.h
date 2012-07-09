#import <Foundation/NSObject.h>
#import <xpc/xpc.h>

@interface NSObject (XPCInterop)

+ (id) objectWithXPCObject:(xpc_object_t)xpcObject;
- (xpc_object_t) XPCObject;

@end
