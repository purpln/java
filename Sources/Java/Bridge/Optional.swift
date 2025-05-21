import JavaRuntime
import JavaTypes

extension Optional: JavaCallable where Wrapped: JavaCallable {
    public static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        Wrapped.jniMethodCall(in: environment)
    }
    
    public static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        Wrapped.jniStaticMethodCall(in: environment)
    }
}

extension Optional: JavaStorable where Wrapped: JavaStorable {
    public static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        Wrapped.jniFieldGet(in: environment)
    }
    
    public static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        Wrapped.jniFieldSet(in: environment)
    }
    
    public static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        Wrapped.jniStaticFieldGet(in: environment)
    }
    
    public static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        Wrapped.jniStaticFieldSet(in: environment)
    }
}

extension Optional: JavaSequence where Wrapped: JavaSequence {
    public static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        Wrapped.jniNewArray(in: environment)
    }
    
    public static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<Wrapped.JNIType> {
        Wrapped.jniGetArrayRegion(in: environment)
    }
    
    public static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<Wrapped.JNIType> {
        Wrapped.jniSetArrayRegion(in: environment)
    }
}

extension Optional: JavaValue where Wrapped: JavaValue {
    public typealias JNIType = Wrapped.JNIType
    
    public static var javaType: JavaType {
        Wrapped.javaType
    }
    
    public init(fromJNI value: JNIType, in environment: JNIEnvironment) {
        self = Wrapped(fromJNI: value, in: environment)
    }
    
    public func getJNIValue(in environment: JNIEnvironment) -> JNIType {
        switch self {
        case let value?: value.getJNIValue(in: environment)
        case nil: Self.jniPlaceholderValue
        }
    }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> {
        Wrapped.jvalueKeyPath
    }
    
    public static var jniPlaceholderValue: JNIType {
        Wrapped.jniPlaceholderValue
    }
}
