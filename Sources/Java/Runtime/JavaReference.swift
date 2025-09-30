import JavaRuntime

public class JavaReference {
    public private(set) var reference: jobject?
    public let environment: JNIEnvironment
    
    public init(object: jobject, in environment: JNIEnvironment) throws {
        guard let reference = environment.interface.NewGlobalRef(environment, object) else {
            fatalError("memory allocation failure or jobject is invalid or exception pending from a prior JNI call")
        }
        self.reference = reference
        self.environment = environment
    }
    
    deinit {
        retrieve()
    }
    
    private func retrieve() {
        guard let reference = reference else { return }
        environment.interface.DeleteGlobalRef(environment, reference)
        self.reference = nil
    }
}

//env->ExceptionCheck()
//env->ExceptionDescribe()
//env->ExceptionClear()
