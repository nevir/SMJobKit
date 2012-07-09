#import "SMJClient.h"

@implementation SMJClient

#pragma mark - Public Interface

+ (NSString*) bundledVersion
{
  return nil;
}

+ (NSString*) installedVersion
{
  return nil;
}

+ (BOOL) installWithError:(NSError **)error
{
  return NO;
}

+ (BOOL) uninstallWithError:(NSError **)error
{
  return NO;
}


#pragma mark - Abstract Interface

+ (NSString*) serviceIdentifier
{
  [NSException raise:@"NotImplementedException" format:@"You need to implement serviceIdentifier on %@!", self];
  return nil;
}



@end
