#import "NSString+XPCInterop.h"


@interface NSStringInteropTests : SenTestCase {
  xpc_object_t xpcString;
}

@end

@implementation NSStringInteropTests

- (void)tearDown
{
  if (xpcString != NULL)
  {
    xpc_release(xpcString);
    xpcString = NULL;
  }
  
  [super tearDown];
}

#pragma mark - To XPC

- (void) testNSStringToXPCString
{
  xpcString = [@"안녕" XPCString];

  STAssertEquals(strcmp(xpc_string_get_string_ptr(xpcString), "안녕"), 0, @"Failed to convert NSString to XPC string!");
}

- (void) testNSStringToXPCObject
{
  xpcString = [@"ohai" XPCObject];
  
  STAssertEquals(strcmp(xpc_string_get_string_ptr(xpcString), "ohai"), 0, @"Failed to convert NSString to XPC string!");
}


#pragma mark - From XPC

- (void) testXPCStringToNSString
{
  xpcString = xpc_string_create("ohai");
 
  STAssertEqualObjects([NSString stringWithXPCString:xpcString], @"ohai", @"Failed to convert XPC string to NSString!");
}

- (void) testXPCObjectToNSString
{
  xpcString = xpc_int64_create(1234);
  
  STAssertThrowsSpecificNamed([NSString stringWithXPCString:xpcString], NSException, @"BadArgument", @"A non-string XPC object should throw!");
} 

@end
