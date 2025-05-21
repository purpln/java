import JavaRuntime
import JavaTypes

public typealias JNIMethodCall<Result> = (JNIEnvironment, jobject, jmethodID, UnsafePointer<jvalue>) -> Result
public typealias JNIFieldGet<Property> = (JNIEnvironment, jobject, jfieldID) -> Property
public typealias JNIFieldSet<Property> = (JNIEnvironment, jobject, jfieldID, Property) -> Void
public typealias JNIStaticMethodCall<Result> = (JNIEnvironment, jobject, jmethodID, UnsafePointer<jvalue>) -> Result
public typealias JNIStaticFieldGet<Property> = (JNIEnvironment, jobject, jfieldID) -> Property
public typealias JNIStaticFieldSet<Property> = (JNIEnvironment, jobject, jfieldID, Property) -> Void
public typealias JNINewArray = (JNIEnvironment, jsize) -> jobject?
public typealias JNIGetArrayRegion<Element> = (JNIEnvironment, jobject, jsize, jsize, UnsafeMutablePointer<Element>) -> Void
public typealias JNISetArrayRegion<Element> = (JNIEnvironment, jobject, jsize, jsize, UnsafePointer<Element>) -> Void

public protocol JavaValue: ~Copyable {
    associatedtype JNIType
    
    static var javaType: JavaType { get }
    
    init(fromJNI value: JNIType, in environment: JNIEnvironment)
    
    func getJNIValue(in environment: JNIEnvironment) -> JNIType
    
    static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { get }
    
    static var jniPlaceholderValue: JNIType { get }
}

extension JavaValue {
    public func getJValue(in environment: JNIEnvironment) -> jvalue {
        var result = jvalue()
        result[keyPath: Self.jvalueKeyPath] = getJNIValue(in: environment)
        return result
    }
    
    public init(fromJava value: jvalue, in environment: JNIEnvironment) {
        self.init(fromJNI: value[keyPath: Self.jvalueKeyPath], in: environment)
    }
}

extension JavaValue where JNIType == Self {
    public func getJNIValue(in environment: JNIEnvironment) -> JNIType { self }
    
    public init(fromJNI value: JNIType, in environment: JNIEnvironment) {
        self = value
    }
}

extension JavaValue {
    public static func withClass<Result>(
        in environment: JNIEnvironment,
        _ body: (jclass) throws -> Result
    ) throws -> Result {
        let resolvedClass = try environment.translatingExceptions {
            environment.interface.FindClass(environment, Self.javaType.className)
        }
        return try body(resolvedClass!)
    }
}

public protocol JavaCallable: JavaValue {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType>
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType>
}

public protocol JavaStorable: JavaValue {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType>
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType>
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType>
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType>
}

public protocol JavaSequence: JavaValue {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType>
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType>
}

public protocol JavaConvertible: JavaCallable, JavaStorable {
    
}

public protocol JavaRepresentable: JavaCallable, JavaStorable where JNIType == jobject? {
    static var javaClassName: String { get }
    
    init(holder: JavaReference)
    
    var holder: JavaReference { get }
}

extension JavaRepresentable {
    public func getJNIValue(in environment: JNIEnvironment) -> JNIType {
        holder.object
    }
    
    public init(fromJNI value: JNIType, in environment: JNIEnvironment) {
        let holder = JavaReference(object: value!, environment: environment)
        self.init(holder: holder)
    }
    
    public static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.l }
    
    public static var javaType: JavaType {
        JavaType(className: javaClassName)
    }
    
    public static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallObjectMethodA
    }
    
    public static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetObjectField
    }
    
    public static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetObjectField
    }
    
    public static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticObjectMethodA
    }
    
    public static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticObjectField
    }
    
    public static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticObjectField
    }
    
    public static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        return { environment, size in
            try! withClass(in: environment) { jniClass in
                environment.interface.NewObjectArray(environment, size, jniClass, nil)
            }
        }
    }
    
    public static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        return { environment, array, start, length, outPointer in
            let buffer = UnsafeMutableBufferPointer(start: outPointer, count: Int(length))
            for i in start..<start + length {
                buffer.initializeElement(
                    at: Int(i),
                    to: environment.interface.GetObjectArrayElement(environment, array, Int32(i))
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
    
    public static var jniPlaceholderValue: jclass? {
        nil
    }
}

extension JavaRepresentable {
    public init(this: jobject, environment: JNIEnvironment) {
        let holder = JavaReference(object: this, environment: environment)
        self.init(holder: holder)
    }
    
    public var this: jobject {
        holder.object!
    }
    
    public var environment: JNIEnvironment {
        holder.environment
    }
    
    static var javaClassNameWithSlashes: String {
        let sequence = javaClassName.map { $0 == "." ? "/" as Character : $0 }
        return String(sequence)
    }
}
