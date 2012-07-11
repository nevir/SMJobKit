#import "NSArray+XPCInterop.h"


@implementation NSArray (XPCInterop)

+ (id) arrayWithXPCArray:(xpc_object_t)xpcArray
{
  AssertXPCObjectType(xpcArray, XPC_TYPE_ARRAY);
  
  NSMutableArray* array = [NSMutableArray arrayWithCapacity:xpc_array_get_count(xpcArray)];
  xpc_array_apply(xpcArray, ^bool(size_t index, xpc_object_t xpcValue)
  {
    [array addObject:[NSObject objectWithXPCObject:xpcValue]];
    
    return true;
  });
  
  return array;
}

- (xpc_object_t) XPCArray
{
  xpc_object_t objects[self.count];
  
  for (NSUInteger i = 0; i < self.count; i++)
  {
    objects[i] = [[self objectAtIndex:i] XPCObject];
  }
  
  xpc_object_t result = xpc_array_create(objects, self.count);
  
  // xpc_array_create retains the input objects, so we need to clean up our temporary objects.
  for (NSUInteger i = 0; i < self.count; i++)
  {
    SAFE_XPC_RELEASE(objects[i]);
  }
  
  return result;
}

- (xpc_object_t) XPCObject
{
  return [self XPCArray];
}

@end
