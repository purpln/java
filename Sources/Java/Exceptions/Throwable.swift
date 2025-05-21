import JavaRuntime

open class Throwable: JavaObject, @unchecked Sendable {
    open override class var javaClassName: String {
        "java.lang.Throwable"
    }
    
    open func getMessage() -> String {
        return try! call(method: "getMessage")
    }
}

extension Throwable: Error, CustomStringConvertible {
    public var description: String {
        return getMessage()
    }
}
