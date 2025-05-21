import JavaRuntime
import JavaTypes

extension Float: JavaCallable {
    public static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallFloatMethodA
    }
    
    public static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticFloatMethodA
    }
}

extension Float: JavaStorable {
    public static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetFloatField
    }
    
    public static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetFloatField
    }
    
    public static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticFloatField
    }
    
    public static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticFloatField
    }
}

extension Float: JavaSequence {
    public static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewFloatArray
    }
    
    public static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetFloatArrayRegion
    }
    
    public static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetFloatArrayRegion
    }
}

extension Float: JavaValue {
    public typealias JNIType = jfloat
    
    public static var javaType: JavaType { .float }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.f }
    
    public static var jniPlaceholderValue: jfloat { 0 }
}

extension Double: JavaCallable {
    public static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallDoubleMethodA
    }
    
    public static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticDoubleMethodA
    }
}

extension Double: JavaStorable {
    public static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetDoubleField
    }
    
    public static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetDoubleField
    }
    
    public static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticDoubleField
    }
    
    public static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticDoubleField
    }
}

extension Double: JavaSequence {
    public static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewDoubleArray
    }
    
    public static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetDoubleArrayRegion
    }
    
    public static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetDoubleArrayRegion
    }
}

extension Double: JavaValue {
    public typealias JNIType = jdouble
    
    public static var javaType: JavaType { .double }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.d }
    
    public static var jniPlaceholderValue: jdouble { 0 }
}
