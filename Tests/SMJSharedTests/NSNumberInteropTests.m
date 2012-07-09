#import "NSNumber+XPCInterop.h"


@interface NSNumberInteropTests : SenTestCase

@end

@implementation NSNumberInteropTests

#pragma mark - To XPC

- (void) testBoolToXPCBool
{
  AssertXPCBool([[NSNumber numberWithBool:YES] XPCNumber], YES, @"true");
  AssertXPCBool([[NSNumber numberWithBool:NO]  XPCNumber], NO,  @"false");
}

- (void) testCharToXPCInt
{
  AssertXPCInt([[NSNumber numberWithChar:SCHAR_MIN] XPCNumber], SCHAR_MIN, @"min char");
  AssertXPCInt([[NSNumber numberWithChar:0] XPCNumber], 0, @"char 0");
  AssertXPCInt([[NSNumber numberWithChar:1] XPCNumber], 1, @"char 1");
  AssertXPCInt([[NSNumber numberWithChar:-27] XPCNumber], -27, @"a char");
  AssertXPCInt([[NSNumber numberWithChar:SCHAR_MAX] XPCNumber], SCHAR_MAX, @"max char");
}

- (void) testShortToXPCInt
{
  AssertXPCInt([[NSNumber numberWithShort:SHRT_MIN] XPCNumber], SHRT_MIN, @"min short");
  AssertXPCInt([[NSNumber numberWithShort:120] XPCNumber], 120, @"a short");
  AssertXPCInt([[NSNumber numberWithShort:SHRT_MAX] XPCNumber], SHRT_MAX, @"max short");
}

- (void) testIntToXPCInt
{
  AssertXPCInt([[NSNumber numberWithInt:INT_MIN] XPCNumber], INT_MIN, @"min int");
  AssertXPCInt([[NSNumber numberWithInt:-12727] XPCNumber], -12727, @"an int");
  AssertXPCInt([[NSNumber numberWithInt:INT_MAX] XPCNumber], INT_MAX, @"max int");
}

- (void) testLongToXPCInt
{
  AssertXPCInt([[NSNumber numberWithLong:LONG_MIN] XPCNumber], LONG_MIN, @"min long");
  AssertXPCInt([[NSNumber numberWithLong:483272382] XPCNumber], 483272382, @"a long");
  AssertXPCInt([[NSNumber numberWithLong:LONG_MAX] XPCNumber], LONG_MAX, @"max long");
}

- (void) testLongLongToXPCInt
{
  AssertXPCInt([[NSNumber numberWithLongLong:LLONG_MIN] XPCNumber], LLONG_MIN, @"min long long");
  AssertXPCInt([[NSNumber numberWithLongLong:-587293471267283] XPCNumber], -587293471267283, @"a long long");
  AssertXPCInt([[NSNumber numberWithLongLong:LLONG_MAX] XPCNumber], LLONG_MAX, @"max long long");
}

- (void) testLongLongToXPCUIntCoercion
{
  AssertXPCUInt([[NSNumber numberWithUnsignedLongLong:ULLONG_MAX] XPCNumber], ULLONG_MAX, @"max unsigned long long");
}

- (void) testFloatToXPCDouble
{
  AssertXPCDouble([[NSNumber numberWithFloat:721.127f] XPCNumber], 721.127f, @"a float");
}

- (void) testDoubleToXPCDouble
{
  AssertXPCDouble([[NSNumber numberWithDouble:1713.12482732] XPCNumber], 1713.12482732, @"a double");
}

- (void) testNumberToXPCObject
{
  AssertXPCBool([[NSNumber numberWithBool:YES] XPCObject], YES, @"true");
  AssertXPCInt([[NSNumber numberWithChar:-27] XPCObject], -27, @"a char");
  AssertXPCInt([[NSNumber numberWithShort:120] XPCObject], 120, @"a short");
  AssertXPCInt([[NSNumber numberWithInt:-12727] XPCObject], -12727, @"an int");
  AssertXPCInt([[NSNumber numberWithLong:483272382] XPCObject], 483272382, @"a long");
  AssertXPCInt([[NSNumber numberWithLongLong:-587293471267283] XPCObject], -587293471267283, @"a long long");
  AssertXPCUInt([[NSNumber numberWithUnsignedLongLong:ULLONG_MAX] XPCObject], ULLONG_MAX, @"max unsigned long long");
}


#pragma mark - From XPC

- (void) testXPCBoolToNSNumber
{
  STAssertEqualObjects([NSNumber numberWithXPCNumber:xpc_bool_create(true)],  [NSNumber numberWithBool:YES], @"Failed to convert XPC bool true to NSNumber");
  STAssertEqualObjects([NSNumber numberWithXPCNumber:xpc_bool_create(false)], [NSNumber numberWithBool:NO],  @"Failed to convert XPC bool false to NSNumber");
}

- (void) testXPCIntToNSNumber
{
  STAssertEqualObjects([NSNumber numberWithXPCNumber:xpc_int64_create(LLONG_MIN)], [NSNumber numberWithLongLong:LLONG_MIN], @"Failed to convert XPC int64 to NSNumber");
  STAssertEqualObjects([NSNumber numberWithXPCNumber:xpc_int64_create(LLONG_MAX)], [NSNumber numberWithLongLong:LLONG_MAX], @"Failed to convert XPC int64 to NSNumber");
}

- (void) testXPCUIntToNSNumber
{
  STAssertEqualObjects([NSNumber numberWithXPCNumber:xpc_uint64_create(ULLONG_MAX)], [NSNumber numberWithUnsignedLongLong:ULLONG_MAX], @"Failed to convert XPC uint64 to NSNumber");
}

- (void) testXPCDoubleToNSNumber
{
  STAssertEqualObjects([NSNumber numberWithXPCNumber:xpc_double_create(1713.12482732)], [NSNumber numberWithDouble:1713.12482732], @"Failed to convert XPC double to NSNumber");
}

- (void) testXPCObjectToNSString
{
  STAssertThrowsSpecificNamed([NSNumber numberWithXPCNumber:xpc_string_create("ohai")], NSException, @"BadArgument", @"A non-numeric XPC object should throw!");
}

@end
