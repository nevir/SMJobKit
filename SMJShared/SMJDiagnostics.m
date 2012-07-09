#import "SMJDiagnostics.h"

@implementation SMJDiagnostics

+ (NSString*) stringForXPCType:(xpc_type_t)type
{
  if (type == XPC_TYPE_ARRAY)      return @"XPC_TYPE_ARRAY";
  if (type == XPC_TYPE_BOOL)       return @"XPC_TYPE_BOOL";
  if (type == XPC_TYPE_CONNECTION) return @"XPC_TYPE_CONNECTION";
  if (type == XPC_TYPE_DATA)       return @"XPC_TYPE_DATA";
  if (type == XPC_TYPE_DATE)       return @"XPC_TYPE_DATE";
  if (type == XPC_TYPE_DICTIONARY) return @"XPC_TYPE_DICTIONARY";
  if (type == XPC_TYPE_DOUBLE)     return @"XPC_TYPE_DOUBLE";
  if (type == XPC_TYPE_ENDPOINT)   return @"XPC_TYPE_ENDPOINT";
  if (type == XPC_TYPE_ERROR)      return @"XPC_TYPE_ERROR";
  if (type == XPC_TYPE_FD)         return @"XPC_TYPE_FD";
  if (type == XPC_TYPE_INT64)      return @"XPC_TYPE_INT64";
  if (type == XPC_TYPE_NULL)       return @"XPC_TYPE_NULL";
  if (type == XPC_TYPE_SHMEM)      return @"XPC_TYPE_SHMEM";
  if (type == XPC_TYPE_STRING)     return @"XPC_TYPE_STRING";
  if (type == XPC_TYPE_UINT64)     return @"XPC_TYPE_UINT64";
  if (type == XPC_TYPE_UUID)       return @"XPC_TYPE_UUID";
  
  return @"Unknown XPC Type!";
}

@end
