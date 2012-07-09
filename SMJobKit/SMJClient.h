#import <Foundation/NSObject.h>
#import <Foundation/NSError.h>

// An abstract superclass for system-level launchd helper jobs
@interface SMJClient : NSObject

+ (NSString*) bundledVersion;
+ (NSString*) installedVersion;

+ (BOOL) installWithError:(NSError **)error;
+ (BOOL) uninstallWithError:(NSError **)error;

// Must be implemented by subclasses
+ (NSString*) serviceIdentifier;

@end
