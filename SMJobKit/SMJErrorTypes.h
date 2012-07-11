typedef enum {
  
  // A failure when referencing a bundle that doesn't exist (or bad perms)
  SMJErrorCodeBundleNotFound = 1000,
  // A failure when trying to get the SecStaticCode for a bundle, but it is unsigned
  SMJErrorCodeUnsignedBundle = 1001,
  // Unknown failure when calling SecStaticCodeCreateWithPath
  SMJErrorCodeBadBundleSecurity = 1002,
  // Unknown failure when calling SecCodeCopySigningInformation for a bundle
  SMJErrorCodeBadBundleCodeSigningDictionary = 1003,
  
} SMJErrorCode;
