import JavaRuntime

public typealias JNIMethodCall<Result> = (JNIEnvironment, jobject, jmethodID, UnsafePointer<jvalue>) -> Result?
public typealias JNIFieldGet<Property> = (JNIEnvironment, jobject, jfieldID) -> Property?
public typealias JNIFieldSet<Property> = (JNIEnvironment, jobject, jfieldID, Property) -> Void
public typealias JNIStaticMethodCall<Result> = (JNIEnvironment, jobject, jmethodID, UnsafePointer<jvalue>) -> Result?
public typealias JNIStaticFieldGet<Property> = (JNIEnvironment, jobject, jfieldID) -> Property?
public typealias JNIStaticFieldSet<Property> = (JNIEnvironment, jobject, jfieldID, Property) -> Void
public typealias JNINewArray = (JNIEnvironment, jsize) -> jobject?
public typealias JNIGetArrayRegion<Element> = (JNIEnvironment, jobject, jsize, jsize, UnsafeMutablePointer<Element>) -> Void
public typealias JNISetArrayRegion<Element> = (JNIEnvironment, jobject, jsize, jsize, UnsafePointer<Element>) -> Void
