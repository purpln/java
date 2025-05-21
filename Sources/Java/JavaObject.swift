import JavaRuntime

open class JavaObject: JavaRepresentable {
    open class var javaClassName: String {
        "java.lang.Object"
    }

    public var holder: JavaReference

    public required init(holder: JavaReference) {
        self.holder = holder
    }
    /*
    @_nonoverride
    public convenience init(environment: JNIEnvironment) {
        let this = try! Self.dynamicJavaNewObjectInstance(in: environment)
        self.init(this: this, environment: environment)
    }
    
    open func toString() -> String {
        return try! dynamicJavaMethodCall(methodName: "toString", resultType: String.self)
    }
    */
}
