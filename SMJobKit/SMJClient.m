#import "SMJClient.h"

#import "SMJClientUtility.h"


@interface SMJClient ()

// Service Information
+ (NSString*) bundledServicePath;
+ (NSString*) installedServicePath;

// Utility
+ (CFStringRef) cfIdentifier;

@end

@implementation SMJClient

#pragma mark - Abstract Interface

+ (NSString*) serviceIdentifier
{
  [NSException raise:@"NotImplementedException" format:@"You need to implement serviceIdentifier on %@!", self];
  return nil;
}


#pragma mark - Public Interface

+ (NSString*) bundledVersion
{
  return [SMJClientUtility versionForBundlePath:[self bundledServicePath]];
}

+ (NSString*) installedVersion
{
  return [SMJClientUtility versionForBundlePath:[self installedServicePath]];
}

+ (BOOL) installWithPrompt:(NSString*)prompt error:(NSError **)error
{
  if ([self installedVersion] && [[self installedVersion] isEqualTo:[self bundledVersion]])
  {
    NSLog(@"%@ (%@) is already current, skipping install.", [self serviceIdentifier], [self bundledVersion]);
    return YES;
  }
  
  if ([self installedVersion])
  {
    if (![self uninstallWithError:error]) return NO;
  }
  
  AuthorizationRef authRef = [SMJClientUtility authWithRight:kSMRightBlessPrivilegedHelper prompt:prompt error:error];
  if (authRef == NULL) return NO;
  
  // Here's the good stuff
  CFErrorRef cfError;
  if (!SMJobBless(kSMDomainSystemLaunchd, [self cfIdentifier], authRef, &cfError))
  {
    NSError* blessError = (__bridge NSError*)cfError;
    SET_ERROR(SMJErrorUnableToBless, @"SMJobBless Failure (code %d): %@", blessError.code, [blessError localizedDescription]);
    return NO;
  }
  
  NSLog(@"%@ (%@) installed successfully", [self serviceIdentifier], [self bundledVersion]);
  return YES;
}


+ (BOOL) uninstallWithError:(NSError **)error
{
  return NO;
}


#pragma mark - Diagnostics

+ (NSArray*) checkForProblems
{
  NSError* error;
  NSMutableArray* errors = [NSMutableArray array];
  
  error = nil;
  [SMJClientUtility versionForBundlePath:[self bundledServicePath] error:&error];
  if (error) [errors addObject:error];
  
  return (errors.count == 0) ? nil : errors;
}


#pragma mark - Service Information

+ (NSString*) bundledServicePath
{
  NSString* helperRelative = [NSString stringWithFormat:@"Contents/Library/LaunchServices/%@", self.serviceIdentifier];
  
  return [[NSBundle bundleForClass:self].bundlePath stringByAppendingPathComponent:helperRelative];
}

+ (NSString*) installedServicePath
{
  NSDictionary* jobData = (__bridge NSDictionary*)SMJobCopyDictionary(kSMDomainSystemLaunchd, self.cfIdentifier);
  
  return [[jobData objectForKey:@"ProgramArguments"] objectAtIndex:0];
}


#pragma mark - Utility

+ (CFStringRef) cfIdentifier
{
  return (__bridge CFStringRef)self.serviceIdentifier;
}

@end
