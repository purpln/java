import JavaRuntime
import JavaTypes

extension String: JavaValue {
    public typealias JNIType = jstring
    
    public init(jni value: JNIType, in environment: JNIEnvironment) {
        var isCopy: jboolean = 0
        guard let cString = environment.interface.GetStringUTFChars(environment, value, &isCopy) else {
            fatalError("memory allocation failure or jstring is invalid or exception pending from a prior JNI call")
        }
        defer { environment.interface.ReleaseStringUTFChars(environment, value, cString) }
        self = String(cString: cString)
    }
    
    public func jni(in environment: JNIEnvironment) -> JNIType {
        let utfBuffer = Array(utf16)
        guard let result = environment.interface.NewString(environment, utfBuffer, CInt(utfBuffer.count)) else {
            fatalError("memory allocation failure or invalid arguments or exception pending from a prior JNI call")
        }
        return result
    }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.l }
    
    public static var javaType: JavaType {
        .class(package: "java.lang", name: "String")
    }
}

extension String: JavaCallable {}

extension String: JavaStorable {}

extension String: JavaSequence {}
