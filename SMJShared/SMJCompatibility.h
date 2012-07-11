
// Only exists on 10.8
// #import <os/object.h>

#if OS_OBJECT_USE_OBJC_RETAIN_RELEASE && __has_feature(objc_arc)
  #define SAFE_XPC_RELEASE(object)
#else
  #define SAFE_XPC_RELEASE(object) xpc_release(object)
#endif
