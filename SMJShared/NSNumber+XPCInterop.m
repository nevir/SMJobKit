#import "NSNumber+XPCInterop.h"

#import <CoreFoundation/CFNumber.h>
#import <Foundation/NSException.h>


static NSNumber* maxLongLong = nil;

@implementation NSNumber (XPCInterop)

+ (id) numberWithXPCNumber:(xpc_object_t)xpcNumber
{
  xpc_type_t xpcType = xpc_get_type(xpcNumber);
  
  if (xpcType == XPC_TYPE_BOOL)   return [self numberWithBool:xpc_bool_get_value(xpcNumber)];
  if (xpcType == XPC_TYPE_DOUBLE) return [self numberWithDouble:xpc_double_get_value(xpcNumber)];
  if (xpcType == XPC_TYPE_INT64)  return [self numberWithInteger:xpc_int64_get_value(xpcNumber)];
  if (xpcType == XPC_TYPE_UINT64) return [self numberWithUnsignedInteger:xpc_uint64_get_value(xpcNumber)];
    
  [NSException raise:@"BadArgument" format:@"Expected a numeric or bool XPC object.  Got %@", [SMJDiagnostics stringForXPCType:xpc_get_type(xpcNumber)]];
  return nil;
}

- (xpc_object_t) XPCNumber
{
  if (!maxLongLong)
    maxLongLong = [[NSNumber alloc] initWithLongLong:LLONG_MAX];
  
  switch (CFNumberGetType((__bridge CFNumberRef)self))
  {
    case kCFNumberFloatType:
    case kCFNumberDoubleType:
    case kCFNumberFloat32Type:
    case kCFNumberFloat64Type:
    case kCFNumberCGFloatType:
      return xpc_double_create([self doubleValue]);
      
    case kCFNumberSInt8Type:
    case kCFNumberSInt16Type:
    case kCFNumberSInt32Type:
    case kCFNumberShortType:
    case kCFNumberIntType:
    case kCFNumberLongType:
      return xpc_int64_create([self longLongValue]);
    
    // CFNumber / NSNumber stores all numbers as signed, so we need to be careful here.
    case kCFNumberSInt64Type:
    case kCFNumberLongLongType:
    case kCFNumberCFIndexType:
    case kCFNumberNSIntegerType:
      if ([self compare:maxLongLong] == NSOrderedDescending)
      {
        return xpc_uint64_create([self unsignedLongLongValue]);
      }
      else
      {
        return xpc_int64_create([self longLongValue]);
      }

    case kCFNumberCharType:
      // Booleans are encoded as chars, so we've gotta do some extra testing.
      if ([self isKindOfClass:[[NSNumber numberWithBool:YES] class]])
      {
        return xpc_bool_create([self boolValue]);
      }
      else 
      {
        return xpc_int64_create([self longLongValue]);
      }
  }
  
  return nil;
}

- (xpc_object_t) XPCObject
{
  return [self XPCNumber];
}

@end
