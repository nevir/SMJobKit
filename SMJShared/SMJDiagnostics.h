#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSException.h>
#import <xpc/xpc.h>

@interface SMJDiagnostics : NSObject

+ (NSString*) stringForXPCType:(xpc_type_t)type;

@end

#define AssertXPCObjectType(object, type)\
  if (xpc_get_type(object) != type)\
    [NSException raise:@"BadArgument" format:@"Expected an object of %@.  Got %@", [SMJDiagnostics stringForXPCType:type], [SMJDiagnostics stringForXPCType:xpc_get_type(object)]];
