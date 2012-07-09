#import "NSObject+XPCInterop.h"

#import "NSArray+XPCInterop.h"
#import "NSDictionary+XPCInterop.h"
#import "NSNumber+XPCInterop.h"
#import "NSString+XPCInterop.h"

#import <Foundation/NSException.h>


@implementation NSObject (XPCInterop)

+ (id) objectWithXPCObject:(xpc_object_t)xpcObject
{
  xpc_type_t objectType = xpc_get_type(xpcObject);

  if (objectType == XPC_TYPE_ARRAY)      return [NSArray arrayWithXPCArray:xpcObject];
  if (objectType == XPC_TYPE_BOOL)       return [NSNumber numberWithXPCNumber:xpcObject];
  // if (objectType == XPC_TYPE_CONNECTION)
  // if (objectType == XPC_TYPE_DATA)
  // if (objectType == XPC_TYPE_DATE)
  if (objectType == XPC_TYPE_DICTIONARY) return [NSDictionary dictionaryWithXPCDictionary:xpcObject];
  if (objectType == XPC_TYPE_DOUBLE)     return [NSNumber numberWithXPCNumber:xpcObject];
  // if (objectType == XPC_TYPE_ENDPOINT)
  // if (objectType == XPC_TYPE_ERROR)
  // if (objectType == XPC_TYPE_FD)
  if (objectType == XPC_TYPE_INT64)      return [NSNumber numberWithXPCNumber:xpcObject];
  // if (objectType == XPC_TYPE_NULL)
  // if (objectType == XPC_TYPE_SHMEM)
  if (objectType == XPC_TYPE_STRING)     return [NSString stringWithXPCString:xpcObject];
  if (objectType == XPC_TYPE_UINT64)     return [NSNumber numberWithXPCNumber:xpcObject];
  // if (objectType == XPC_TYPE_UUID)

  [NSException raise:@"NotImplemented" format:@"Coercion from %@ is unsupported", [SMJDiagnostics stringForXPCType:objectType]];
  return nil;
}

- (xpc_object_t) XPCObject
{
  [NSException raise:@"NotImplemented" format:@"%@ doesn't implement -XPCObject!", [self class]];
  return NULL;
}

@end
