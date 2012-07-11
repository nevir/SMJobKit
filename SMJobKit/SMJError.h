@interface SMJError : NSError

+ (NSError*) errorWithCode:(NSInteger)code message:(NSString*)message;

@end

#define SET_ERROR(code, messageFormat...)\
  if (error != NULL)\
  {\
    *error = [SMJError errorWithCode:code message:[NSString stringWithFormat:messageFormat]];\
  }\
