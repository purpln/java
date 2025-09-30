import JavaRuntime
import JavaTypes

public protocol JavaIntractable: JavaValue where JNIType == jobject {
    static var javaClassName: String { get }
    
    init(holder: JavaReference)
    
    var holder: JavaReference { get }
}

public extension JavaIntractable {
    init(jni value: JNIType, in environment: JNIEnvironment) throws {
        let holder = try JavaReference(object: value, in: environment)
        self.init(holder: holder)
    }
    
    func jni(in environment: JNIEnvironment) throws -> JNIType {
        guard let reference = holder.reference else {
            fatalError("reference retrieved on deinit")
        }
        return reference
    }
    
    static var jvalueKeyPath: WritableKeyPath<jvalue, JNIType> { \.l }
    
    static var javaType: JavaType {
        JavaType(className: javaClassName)
    }
}

public extension JavaIntractable {
    var this: jobject {
        holder.reference!
    }
    
    var environment: JNIEnvironment {
        holder.environment
    }
}
