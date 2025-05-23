import JavaRuntime

open class JavaObject: JavaRepresentable {
    open class var javaClassName: String {
        "java.lang.Object"
    }

    public var holder: JavaReference

    public required init(holder: JavaReference) {
        self.holder = holder
    }
}
