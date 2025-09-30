import JavaRuntime

open class JavaObject: JavaIntractable {
    open class var javaClassName: String {
        "java.lang.Object"
    }

    public var holder: JavaReference

    public required init(holder: JavaReference) {
        self.holder = holder
    }
}

open class JavaClass<T: JavaRepresentable>: JavaObject {
    open override class var javaClassName: String {
        "java.lang.Class"
    }
}
