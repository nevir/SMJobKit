@interface SMJClientTests : SenTestCase
@end

@implementation SMJClientTests

- (void) testBundledVersion
{
  STAssertEqualObjects([SMJTestClient bundledVersion], @"0.01", @"Missing/wrong version");
  STAssertEqualObjects([SMJMissingClient bundledVersion], nil, @"Missing client should return nil for version");
}

- (void) testForProblems
{
  STAssertNil([SMJTestClient checkForProblems], @"TestService should not have problems");
  
  NSArray* errors = [SMJMissingClient checkForProblems];
  STAssertEquals(errors.count, (NSUInteger)1, @"MissingService should have one error");
  NSError* error = [errors objectAtIndex:0];
  STAssertEquals((SMJErrorCode)error.code, SMJErrorCodeBundleNotFound, @"Missing service should be missing");
}

@end
