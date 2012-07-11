@interface SMJClientTests : SenTestCase
@end

@implementation SMJClientTests

- (void) setUp
{
  [super setUp];
}

- (void) tearDown
{
  [super tearDown];
}

- (void) testBundledVersion
{
  STAssertEqualObjects([SMJTestClient bundledVersion], @"0.01", @"Missing/wrong version");
}

@end
