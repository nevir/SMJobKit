#import "NSString+XPCInterop.h"

@implementation NSString (XPCInterop)

+ (id) stringWithXPCString:(xpc_object_t)xpcString
{
  AssertXPCObjectType(xpcString, XPC_TYPE_STRING);
  
  return [self stringWithUTF8String:xpc_string_get_string_ptr(xpcString)];
}

- (xpc_object_t) XPCString
{
  return xpc_string_create([self UTF8String]);
}

- (xpc_object_t) XPCObject
{
  return [self XPCString];
}

@end
