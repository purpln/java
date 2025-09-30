import JavaRuntime

public protocol JavaValue: JavaRepresentable, JavaCallable, JavaStorable, JavaSequence {
    init(jni value: JNIType, in environment: JNIEnvironment) throws
    
    func jni(in environment: JNIEnvironment) throws -> JNIType
    
    static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { get }
}

public extension JavaValue where JNIType == Self {
    init(jni value: JNIType, in environment: JNIEnvironment) {
        self = value
    }
    
    func jni(in environment: JNIEnvironment) -> JNIType {
        self
    }
}
