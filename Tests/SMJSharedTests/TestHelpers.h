#import "SMJDiagnostics.h"

#define AssertXPCTypeEquals(xpcObject, xpcType)\
  if (xpc_get_type(xpcObject) != xpcType)\
    STFail(@"Got a %@ object, expected %@", [SMJDiagnostics stringForXPCType:xpc_get_type(xpcObject)], [SMJDiagnostics stringForXPCType:xpcType]);


#define AssertXPCArray(xpcObject, count, kind)\
  AssertXPCTypeEquals(xpcObject, XPC_TYPE_ARRAY);\
  STAssertEquals(xpc_array_get_count(xpcObject), (size_t)count, @"Bad array count for %@", kind);

#define AssertXPCDictionary(xpcObject, count, kind)\
  AssertXPCTypeEquals(xpcObject, XPC_TYPE_DICTIONARY);\
  STAssertEquals(xpc_dictionary_get_count(xpcObject), (size_t)count, @"Bad dictionary count for %@", kind);

#define AssertXPCString(xpcObject, targetValue, kind)\
  AssertXPCTypeEquals(xpcObject, XPC_TYPE_STRING);\
  if (strcmp(xpc_string_get_string_ptr(xpcObject), targetValue) != 0)\
    STFail(@"Failed to convert %@ to XPC string", kind);

#define AssertXPCBool(xpcObject, targetValue, kind)\
  AssertXPCTypeEquals(xpcObject, XPC_TYPE_BOOL);\
  STAssertEquals(xpc_bool_get_value(xpcObject), (bool)targetValue, @"Failed to convert %@ to XPC bool", kind);

#define AssertXPCInt(xpcObject, targetValue, kind)\
  AssertXPCTypeEquals(xpcObject, XPC_TYPE_INT64);\
  STAssertEquals(xpc_int64_get_value(xpcObject), (long long)targetValue, @"Failed to convert %@ to XPC int64", kind);

#define AssertXPCUInt(xpcObject, targetValue, kind)\
  AssertXPCTypeEquals(xpcObject, XPC_TYPE_UINT64);\
  STAssertEquals(xpc_uint64_get_value(xpcObject), (unsigned long long)targetValue, @"Failed to convert %@ to XPC uint64", kind);

#define AssertXPCDouble(xpcObject, targetValue, kind)\
  AssertXPCTypeEquals(xpcObject, XPC_TYPE_DOUBLE);\
  STAssertEquals(xpc_double_get_value(xpcObject), (double)targetValue, @"Failed to convert %@ to XPC double", kind);


#define AppendXPCArrayValue(array, value)\
  xpc_array_append_value(array, value);\
  xpc_release(value);

#define SetXPCDictionaryValue(dictionary, key, value)\
  xpc_dictionary_set_value(dictionary, key, value);\
  xpc_release(value);
