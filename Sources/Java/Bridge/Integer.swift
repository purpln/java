import JavaRuntime
import JavaTypes

extension Int8: JavaValue {
    public typealias JNIType = jbyte
    
    public static var javaType: JavaType { .byte }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.b }
}

extension UInt16: JavaValue {
    public typealias JNIType = jchar
    
    public static var javaType: JavaType { .char }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.c }
}

extension Int16: JavaValue {
    public typealias JNIType = jshort
    
    public static var javaType: JavaType { .short }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.s }
}

extension Int32: JavaValue {
    public typealias JNIType = jint
    
    public static var javaType: JavaType { .int }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.i }
}

extension Int64: JavaValue {
    public typealias JNIType = jlong
    
    public static var javaType: JavaType { .long }
    
    public func jni(in environment: JNIEnvironment) -> JNIType {
        jlong(self)
    }
    
    public init(jni value: JNIType, in environment: JNIEnvironment) {
        self = Int64(value)
    }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.j }
}
