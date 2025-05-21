import JavaRuntime
import JavaTypes

extension String: JavaCallable {
    public static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallObjectMethodA
    }
    
    public static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticObjectMethodA
    }
}

extension String: JavaStorable {
    public static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetObjectField
    }
    
    public static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetObjectField
    }
    
    public static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticObjectField
    }
    
    public static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticObjectField
    }
}

extension String: JavaSequence {
    public static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        return { environment, size in
            // FIXME: Introduce a JavaString class that we can use for this.
            let stringClass = environment.interface.FindClass(environment, "java/lang/String")
            return environment.interface.NewObjectArray(environment, size, stringClass, nil)
        }
    }
    
    public static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        return { environment, array, start, length, outPointer in
            let buffer = UnsafeMutableBufferPointer(start: outPointer, count: Int(length))
            for i in 0..<length {
                buffer.initializeElement(
                    at: Int(i),
                    to: environment.interface.GetObjectArrayElement(environment, array, Int32(start + i))
                )
            }
        }
    }
    
    public static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        return { environment, array, start, length, outPointer in
            let buffer = UnsafeBufferPointer(start: outPointer, count: Int(length))
            for i in start..<start + length {
                environment.interface.SetObjectArrayElement(environment, array, i, buffer[Int(i)])
            }
        }
    }
}

extension String: JavaValue {
    public typealias JNIType = jstring?
    
    public static var javaType: JavaType {
        .class(package: "java.lang", name: "String")
    }
    
    public init(fromJNI value: JNIType, in environment: JNIEnvironment) {
        guard let value else {
            self.init()
            return
        }
        let cString = environment.interface.GetStringUTFChars(environment, value, nil)!
        defer { environment.interface.ReleaseStringUTFChars(environment, value, cString) }
        self = String(cString: cString)
    }
    
    public func getJNIValue(in environment: JNIEnvironment) -> JNIType {
        var utfBuffer = Array(utf16)
        return environment.interface.NewString(environment, &utfBuffer, Int32(utfBuffer.count))
    }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.l }
    
    public static var jniPlaceholderValue: jstring? { nil }
}
