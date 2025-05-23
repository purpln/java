import JavaRuntime
import JavaTypes

extension Bool: JavaCallable {
    public static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallBooleanMethodA
    }
    
    public static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticBooleanMethodA
    }
}

extension Bool: JavaStorable {
    public static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetBooleanField
    }
    
    public static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetBooleanField
    }
    
    public static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticBooleanField
    }
    
    public static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticBooleanField
    }
}

extension Bool: JavaSequence {
    public static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewBooleanArray
    }
    
    public static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetBooleanArrayRegion
    }
    
    public static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetBooleanArrayRegion
    }
}

extension Bool: JavaValue {
    public typealias JNIType = jboolean
    
    public static var javaType: JavaType { .boolean }
    
    public init(fromJNI value: JNIType, in environment: JNIEnvironment) {
        self = value != 0
    }
    
    public func getJNIValue(in environment: JNIEnvironment) -> JNIType { self ? 1 : 0 }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.z }
    
    public static var jniPlaceholderValue: jboolean { 0 }
}
