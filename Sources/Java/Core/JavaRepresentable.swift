import JavaRuntime
import JavaTypes

public protocol JavaRepresentable: ~Copyable {
    associatedtype JNIType = Void
    
    static var javaType: JavaType { get }
}

public extension JavaRepresentable where JNIType == Void {
    static var javaType: JavaType { .void }
}

public extension JavaRepresentable {
    static func withClass<Result>(
        in environment: JNIEnvironment,
        _ body: (jclass) throws -> Result
    ) throws -> Result {
        let resolvedClass = try environment.translatingExceptions {
            environment.interface.FindClass(environment, Self.javaType.className)
        }
        return try body(resolvedClass)
    }
}
