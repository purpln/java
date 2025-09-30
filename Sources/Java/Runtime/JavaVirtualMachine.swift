import JavaRuntime

public typealias JavaVirtualMachinePointer = UnsafeMutablePointer<JavaVM?>
#if os(Android)
private typealias JNIEnvironmentPointer = UnsafeMutablePointer<JNIEnv?>
#else
private typealias JNIEnvironmentPointer = UnsafeMutableRawPointer
#endif

public final class JavaVirtualMachine: @unchecked Sendable {
    private static let version = JNI_VERSION_1_6
    private let jvm: JavaVirtualMachinePointer
    private let destroyOnDeinit: LockedState<Bool>
    private static let destroyTLS = ThreadLocalStorage(onThreadExit: { _ in })
    
    public init(adopting jvm: JavaVirtualMachinePointer) {
        self.jvm = jvm
        self.destroyOnDeinit = LockedState(initialState: false)
    }
    
    deinit {
        if destroyOnDeinit.withLock({ $0 }) {
            do {
                try destroy()
            } catch {
                fatalError("Failed to destroy the JVM: \(error)")
            }
        }
    }
    
    public func destroy() throws(JavaVirtualMachineError) {
        try detachCurrentThread()
        let result = jvm.pointee!.pointee.DestroyJavaVM(jvm)
        guard result == JNI_OK else {
            throw JavaVirtualMachineError(fromJNIError: result)
        }
        
        destroyOnDeinit.withLock({ $0 = false })
    }
    
    public func environment(asDaemon: Bool = false) throws(JavaVirtualMachineError) -> JNIEnvironment {
        var environment: UnsafeMutableRawPointer? = nil
        let getEnvResult = jvm.pointee!.pointee.GetEnv(
            jvm,
            &environment,
            JavaVirtualMachine.version
        )
        if getEnvResult == JNI_OK, let environment {
            return environment.assumingMemoryBound(to: JNIEnv?.self)
        }
        
#if canImport(Android)
        var jniEnv = environment?.assumingMemoryBound(to: JNIEnv?.self)
#else
        var jniEnv = environment
#endif
        
        let attachResult: jint
        if asDaemon {
            attachResult = jvm.pointee!.pointee.AttachCurrentThreadAsDaemon(jvm, &jniEnv, nil)
        } else {
            attachResult = jvm.pointee!.pointee.AttachCurrentThread(jvm, &jniEnv, nil)
        }
        
        guard attachResult == JNI_OK else {
            throw JavaVirtualMachineError(fromJNIError: attachResult)
        }
        
        JavaVirtualMachine.destroyTLS.set(jniEnv!)
        
#if canImport(Android)
        return jniEnv!
#else
        return jniEnv!.assumingMemoryBound(to: JNIEnv?.self)
#endif
    }
    
    func detachCurrentThread() throws(JavaVirtualMachineError) {
        let result = jvm.pointee!.pointee.DetachCurrentThread(jvm)
        guard result == JNI_OK else {
            throw JavaVirtualMachineError(fromJNIError: result)
        }
    }
}

public enum JavaVirtualMachineError: Error {
    case existingVM
    case jniVersion
    case threadDetached
    case outOfMemory
    case invalidArguments
    case unknown(jint)
    
    init(fromJNIError error: jint) {
        switch error {
        case JNI_EDETACHED: self = .threadDetached
        case JNI_EVERSION: self = .jniVersion
        case JNI_ENOMEM: self = .outOfMemory
        case JNI_EEXIST: self = .existingVM
        case JNI_EINVAL: self = .invalidArguments
        default: self = .unknown(error)
        }
    }
}
