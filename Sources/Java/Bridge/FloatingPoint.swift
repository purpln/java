import JavaRuntime
import JavaTypes

extension Float: JavaValue {
    public typealias JNIType = jfloat
    
    public static var javaType: JavaType { .float }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.f }
}

extension Double: JavaValue {
    public typealias JNIType = jdouble
    
    public static var javaType: JavaType { .double }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.d }
}
