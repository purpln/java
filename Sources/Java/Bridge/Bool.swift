import JavaRuntime
import JavaTypes

extension Bool: JavaValue {
    public typealias JNIType = jboolean
    
    public init(jni value: JNIType, in environment: JNIEnvironment) {
        self = value != 0
    }
    
    public func jni(in environment: JNIEnvironment) -> JNIType {
        self ? 1 : 0
    }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.z }
    
    public static var javaType: JavaType { .boolean }
}

extension Bool: JavaCallable {}

extension Bool: JavaStorable {}

extension Bool: JavaSequence {}
