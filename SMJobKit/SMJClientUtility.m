#import "SMJClientUtility.h"

#import <Security/SecCode.h>


@implementation SMJClientUtility

#pragma mark   Bundle Introspection

+ (NSString*) versionForBundlePath:(NSString*)bundlePath
{
  NSError*  error;
  NSString* version = [self versionForBundlePath:bundlePath error:&error];
  
  if (!version) {
    NSLog(@"Failed to retrieve version of %@: %@", bundlePath, error.localizedDescription);
    return nil;
  }
  
  return version;
}

+ (NSString*) versionForBundlePath:(NSString*)bundlePath error:(NSError**)error
{
  if (!bundlePath) return nil;
  
  // We can't use CFBundleCopyInfoDictionaryForURL, as it breaks our code signing validity.
  SecStaticCodeRef codeRef;
  OSStatus result;
  
  result = SecStaticCodeCreateWithPath((__bridge CFURLRef)[NSURL URLWithString:bundlePath], kSecCSDefaultFlags, &codeRef);
  if (result != noErr)
  {
    if (result == errSecCSUnsigned)
    {
      SET_ERROR(SMJErrorCodeUnsignedBundle, @"Encountered unsigned bundle");
    }
    else if (result == errSecCSStaticCodeNotFound)
    {
      SET_ERROR(SMJErrorCodeBundleNotFound, @"No bundle found at given path");
    }
    else
    {
      SET_ERROR(SMJErrorCodeBadBundleSecurity, @"Failed to create SecStaticCodeRef (errno %d)", result);
    }
    return nil;
  }
  
  CFDictionaryRef codeInfo;
  result = SecCodeCopySigningInformation(codeRef, kSecCSDefaultFlags, &codeInfo);
  if (result != noErr)
  {
    SET_ERROR(SMJErrorCodeBadBundleCodeSigningDictionary, @"Failed to read code signing dictionary (errno %d)", result);
    return nil;
  }
  
  NSDictionary* bundleInfo = (__bridge NSDictionary*)CFDictionaryGetValue(codeInfo, kSecCodeInfoPList);
  if (![bundleInfo isKindOfClass:NSDictionary.class])
  {
    SET_ERROR(SMJErrorCodeBadBundleCodeSigningDictionary, @"kSecCodeInfoPList was not a dictionary (got %@)", bundleInfo);
    return nil;
  }
  
  id versionValue = [bundleInfo objectForKey:@"CFBundleVersion"];
  if (![versionValue isKindOfClass:NSString.class]) return nil;
  
  return versionValue;
}


#pragma mark - Authorization & Security

+ (AuthorizationRef) authWithRight:(AuthorizationString)rightName prompt:(NSString*)prompt
{
  AuthorizationItem   authItem = {rightName, 0, NULL, 0};
  AuthorizationRights authRights = {1, &authItem};
  
  AuthorizationEnvironment environment;
  
  if (prompt)
  {
    AuthorizationItem envItem = {
      kAuthorizationEnvironmentPrompt, [prompt length], (void*)[prompt UTF8String], 0
    };
    
    environment.count = 1;
    environment.items = &envItem;
  }
  else
  {
    environment.count = 0;
    environment.items = NULL;
  }
  
  AuthorizationFlags flags =
  kAuthorizationFlagDefaults
  | kAuthorizationFlagInteractionAllowed
  | kAuthorizationFlagPreAuthorize
  | kAuthorizationFlagExtendRights;
  
  AuthorizationRef authRef;
  OSStatus status = AuthorizationCreate(&authRights, &environment, flags, &authRef);
  if (status != errAuthorizationSuccess)
  {
    NSLog(@"Failed to create AuthorizationRef, return code %i", status);
    return NULL;
  }
  else
  {
    return authRef;
  }
}

@end
