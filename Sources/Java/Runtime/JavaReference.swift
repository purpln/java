import JavaRuntime

public class JavaReference {
    public private(set) var object: jobject?
    public let environment: JNIEnvironment
    
    public init(object: jobject, environment: JNIEnvironment) {
        self.object = environment.interface.NewGlobalRef(environment, object)
        self.environment = environment
    }
    
    deinit {
        retrive()
    }
    
    private func retrive() {
        guard let object = object else { return }
        environment.interface.DeleteGlobalRef(environment, object)
        self.object = nil
    }
}
