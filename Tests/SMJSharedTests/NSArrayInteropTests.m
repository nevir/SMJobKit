#import "NSArray+XPCInterop.h"


@interface NSArrayInteropTests : SenTestCase {
  xpc_object_t xpcArray;
}

@end

@implementation NSArrayInteropTests

- (void) tearDown
{
  if (xpcArray != NULL)
  {
    xpc_release(xpcArray);
    xpcArray = NULL;
  }
  
  [super tearDown];
}


#pragma mark - To XPC

- (void) testEmptyToXPC
{
  xpcArray = [[NSArray arrayWithObjects:nil] XPCArray];
  
  AssertXPCArray(xpcArray, 0, @"empty array");
}

- (void) testPopulatedArrayToXPC
{
  xpcArray = [[NSArray arrayWithObjects:[NSNumber numberWithInt:1234], @"ohai", nil] XPCArray];
  
  AssertXPCArray(xpcArray, 2, @"basic array");

  AssertXPCInt(xpc_array_get_value(xpcArray, 0), 1234, @"basic integer");
  AssertXPCString(xpc_array_get_value(xpcArray, 1), "ohai", @"basic string");
}

- (void) testComplexArrayToXPC
{
  NSArray* nestedArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:1234], [NSNumber numberWithBool:YES], nil];
  NSDictionary* nestedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", [NSNumber numberWithInt:-2727], @"key2", nil];
  
  xpcArray = [[NSArray arrayWithObjects:nestedArray, @"more", nestedDict, nil] XPCArray];
 
  AssertXPCArray(xpcArray, 3, @"complex array");
  
  xpc_object_t nestedXPCArray = xpc_array_get_value(xpcArray, 0);
  AssertXPCArray(nestedXPCArray, 2, @"nested array");
  AssertXPCInt(xpc_array_get_value(nestedXPCArray, 0), 1234, @"number nested in array");
  AssertXPCBool(xpc_array_get_value(nestedXPCArray, 1), YES, @"bool nested in array");
  
  AssertXPCString(xpc_array_get_value(xpcArray, 1), "more", @"basic string");
  
  xpc_object_t nestedXPCDict = xpc_array_get_value(xpcArray, 2);
  AssertXPCDictionary(nestedXPCDict, 2, @"nested dictionary");
  AssertXPCString(xpc_dictionary_get_value(nestedXPCDict, "key1"), "val1", @"string nested in dictionary");
  AssertXPCInt(xpc_dictionary_get_value(nestedXPCDict, "key2"), -2727, @"number nested in dictionary");
}


#pragma mark - From XPC

- (void) testEmptyToNS
{
  xpcArray = xpc_array_create(NULL, 0);
  NSArray* array = [NSArray arrayWithXPCArray:xpcArray];
  
  STAssertEquals(array.count, (NSUInteger)0, @"Bad array count");
}

- (void) testPopulatedToNS
{
  xpcArray = xpc_array_create(NULL, 0);
  AppendXPCArrayValue(xpcArray, xpc_bool_create(YES));
  AppendXPCArrayValue(xpcArray, xpc_string_create("안녕"));
  
  NSArray* array = [NSArray arrayWithXPCArray:xpcArray];
  
  STAssertEquals(array.count, (NSUInteger)2, @"Bad array count");
  STAssertEqualObjects([array objectAtIndex:0], [NSNumber numberWithBool:YES], @"basic boolean");
  STAssertEqualObjects([array objectAtIndex:1], @"안녕", @"basic string");
}

- (void) testComplexToNS
{
  xpc_object_t nestedXPCArray = xpc_array_create(NULL, 0);
  AppendXPCArrayValue(nestedXPCArray, xpc_double_create(27.38237));
  
  xpc_object_t nestedXPCDict = xpc_dictionary_create(NULL, NULL, 0);
  SetXPCDictionaryValue(nestedXPCDict, "someKey", xpc_string_create("foo bar"));
  SetXPCDictionaryValue(nestedXPCDict, "otherKey", xpc_int64_create(12345));
  
  xpcArray = xpc_array_create(NULL, 0);
  AppendXPCArrayValue(xpcArray, nestedXPCDict);
  AppendXPCArrayValue(xpcArray, nestedXPCArray);
  
  NSArray* array = [NSArray arrayWithXPCArray:xpcArray];
  
  STAssertEquals(array.count, (NSUInteger)2, @"Bad array count");

  NSDictionary* nestedDict = [array objectAtIndex:0];
  STAssertEquals(nestedDict.count, (NSUInteger)2, @"Bad nested dictionary count");
  STAssertEqualObjects([nestedDict objectForKey:@"someKey"], @"foo bar", @"basic string");
  STAssertEqualObjects([nestedDict objectForKey:@"otherKey"], [NSNumber numberWithInt:12345], @"basic number");
  
  NSArray* nestedArray = [array objectAtIndex:1];
  STAssertEquals(nestedArray.count, (NSUInteger)1, @"Bad nested array count");
  STAssertEqualObjects([nestedArray objectAtIndex:0], [NSNumber numberWithDouble:27.38237], @"basic double");
}

@end
