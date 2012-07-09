#import "NSObject+XPCInterop.h"

#import <Foundation/NSDictionary.h>
#import <xpc/xpc.h>

@interface NSDictionary (XPCInterop)

+ (id) dictionaryWithXPCDictionary:(xpc_object_t)xpcDictionary;
- (xpc_object_t) XPCDictionary;

@end
