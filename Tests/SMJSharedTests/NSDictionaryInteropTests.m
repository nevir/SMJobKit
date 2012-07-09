#import "NSDictionary+XPCInterop.h"


@interface NSDictionaryInteropTests : SenTestCase {
  xpc_object_t xpcDictionary;
}

@end

@implementation NSDictionaryInteropTests

- (void) tearDown
{
  if (xpcDictionary != NULL)
  {
    xpc_release(xpcDictionary);
    xpcDictionary = NULL;
  }
  
  [super tearDown];
}


#pragma mark - To XPC

- (void) testEmptyToXPC
{
  xpcDictionary = [[NSDictionary dictionaryWithObjectsAndKeys:nil] XPCDictionary];
  
  AssertXPCDictionary(xpcDictionary, 0, @"empty dictionary");
}

- (void) testPopulatedDictionaryToXPC
{
  xpcDictionary = [[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1234], @"ohai", @"stuff", @"what is it", nil] XPCDictionary];
  
  AssertXPCDictionary(xpcDictionary, 2, @"basic dictionary");
  
  AssertXPCInt(xpc_dictionary_get_value(xpcDictionary, "ohai"), 1234, @"basic integer");
  AssertXPCString(xpc_dictionary_get_value(xpcDictionary, "what is it"), "stuff", @"basic string");
}

- (void) testComplexDictionaryToXPC
{
  NSArray* nestedArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:1234], [NSNumber numberWithBool:YES], nil];
  NSDictionary* nestedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", [NSNumber numberWithInt:-2727], @"key2", nil];
  
  xpcDictionary = [[NSDictionary dictionaryWithObjectsAndKeys:nestedArray, @"arr", nestedDict, @"dict", nil] XPCDictionary];
  
  AssertXPCDictionary(xpcDictionary, 2, @"complex array");
  
  xpc_object_t nestedXPCArray = xpc_dictionary_get_value(xpcDictionary, "arr");
  AssertXPCArray(nestedXPCArray, 2, @"nested array");
  AssertXPCInt(xpc_array_get_value(nestedXPCArray, 0), 1234, @"number nested in array");
  AssertXPCBool(xpc_array_get_value(nestedXPCArray, 1), YES, @"bool nested in array");
  
  xpc_object_t nestedXPCDict = xpc_dictionary_get_value(xpcDictionary, "dict");
  AssertXPCDictionary(nestedXPCDict, 2, @"nested dictionary");
  AssertXPCString(xpc_dictionary_get_value(nestedXPCDict, "key1"), "val1", @"string nested in dictionary");
  AssertXPCInt(xpc_dictionary_get_value(nestedXPCDict, "key2"), -2727, @"number nested in dictionary");
}


#pragma mark - From XPC

- (void) testEmptyToNS
{
  xpcDictionary = xpc_dictionary_create(NULL, NULL, 0);
  NSDictionary* dict = [NSDictionary dictionaryWithXPCDictionary:xpcDictionary];
  
  STAssertEquals(dict.count, (NSUInteger)0, @"Bad dictionary count");
}

- (void) testPopulatedToNS
{
  xpcDictionary = xpc_dictionary_create(NULL, NULL, 0);
  SetXPCDictionaryValue(xpcDictionary, "someKey", xpc_bool_create(YES));
  SetXPCDictionaryValue(xpcDictionary, "안녕", xpc_string_create("it means hi"));
  
  NSDictionary* dict = [NSDictionary dictionaryWithXPCDictionary:xpcDictionary];
  
  STAssertEquals(dict.count, (NSUInteger)2, @"Bad dictionary count");
  
  STAssertEqualObjects([dict objectForKey:@"someKey"], [NSNumber numberWithBool:YES], @"basic boolean");
  STAssertEqualObjects([dict objectForKey:@"안녕"], @"it means hi", @"basic string");
}

- (void) testComplexToNS
{
  xpc_object_t nestedXPCArray = xpc_array_create(NULL, 0);
  AppendXPCArrayValue(nestedXPCArray, xpc_double_create(27.38237));
  
  xpc_object_t nestedXPCDict = xpc_dictionary_create(NULL, NULL, 0);
  SetXPCDictionaryValue(nestedXPCDict, "someKey", xpc_string_create("foo bar"));
  SetXPCDictionaryValue(nestedXPCDict, "otherKey", xpc_int64_create(12345));
  
  xpcDictionary = xpc_dictionary_create(NULL, NULL, 0);
  SetXPCDictionaryValue(xpcDictionary, "arr", nestedXPCArray);
  SetXPCDictionaryValue(xpcDictionary, "dict", nestedXPCDict);

  NSDictionary* dict = [NSDictionary dictionaryWithXPCDictionary:xpcDictionary];
  
  STAssertEquals(dict.count, (NSUInteger)2, @"Bad dictionary count");
  
  NSDictionary* nestedDict = [dict objectForKey:@"dict"];
  STAssertEquals(nestedDict.count, (NSUInteger)2, @"Bad nested dictionary count");
  STAssertEqualObjects([nestedDict objectForKey:@"someKey"], @"foo bar", @"basic string");
  STAssertEqualObjects([nestedDict objectForKey:@"otherKey"], [NSNumber numberWithInt:12345], @"basic number");
  
  NSArray* nestedArray = [dict objectForKey:@"arr"];
  STAssertEquals(nestedArray.count, (NSUInteger)1, @"Bad nested array count");
  STAssertEqualObjects([nestedArray objectAtIndex:0], [NSNumber numberWithDouble:27.38237], @"basic double");
}

@end
