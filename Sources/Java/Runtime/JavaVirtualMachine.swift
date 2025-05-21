import JavaRuntime

public typealias JavaVirtualMachinePointer = UnsafeMutablePointer<JavaVM?>

public final class JavaVirtualMachine: @unchecked Sendable {
    private let jvm: JavaVirtualMachinePointer
    private let destroyOnDeinit: LockedState<Bool>
    
    public init(adopting jvm: JavaVirtualMachinePointer, destroyOnDeinit: Bool = false) {
        self.jvm = jvm
        self.destroyOnDeinit = LockedState(initialState: destroyOnDeinit)
    }
    
    deinit {
        do {
            try detachCurrentThread(jvm: jvm)
        } catch {
            fatalError("Failed to detach current thread: \(error)")
        }
        
        guard destroyOnDeinit.withLock({ $0 }) else { return }
        do {
            try destroy()
        } catch {
            fatalError("Failed to destroy the JVM: \(error)")
        }
    }
    
    public func destroy() throws(JavaVirtualMachineError) {
        let result = jvm.pointee!.pointee.DestroyJavaVM(jvm)
        guard result == JNI_OK else {
            throw JavaVirtualMachineError(fromJNIError: result)
        }
        
        destroyOnDeinit.withLock({ $0 = false }) // we destroyed explicitly, disable destroy in deinit
    }
    
    /// Produce the JNI environment for the active thread, attaching this
    /// thread to the JVM if it isn't already.
    ///
    /// - Parameter
    ///   - asDaemon: Whether this thread should be treated as a daemon
    ///     thread in the Java Virtual Machine.
    public func environment(asDaemon: Bool = false) throws(JavaVirtualMachineError) -> JNIEnvironment {
        // Check whether this thread is already attached. If so, return the
        // corresponding environment.
        if let environment = getEnvironment(jvm: jvm) {
            return environment
        }
        
        if asDaemon {
            return try attachCurrentThreadAsDaemon(jvm: jvm)
        } else {
            return try attachCurrentThread(jvm: jvm)
        }
    }
}

/// The JNI version that we depend on.
private let jniVersion = JNI_VERSION_1_6

private func getEnvironment(jvm: JavaVirtualMachinePointer) -> JNIEnvironment? {
    var environment: UnsafeMutableRawPointer? = nil
    let result = jvm.pointee!.pointee.GetEnv(
        jvm,
        &environment,
        jniVersion
    )
    guard result == JNI_OK, let environment else { return nil }
    return environment.assumingMemoryBound(to: JNIEnv?.self)
}

private func attachCurrentThread(jvm: JavaVirtualMachinePointer) throws(JavaVirtualMachineError) -> JNIEnvironment {
#if os(Android)
    var environment: UnsafeMutablePointer<JNIEnv?>? = nil
    let result = withUnsafeMutablePointer(to: &environment, { environment in
        jvm.pointee!.pointee.AttachCurrentThread(jvm, environment, nil)
    })
#else
    var environment: UnsafeMutableRawPointer? = nil
    let result = withUnsafeMutablePointer(to: &environment, { environment in
        jvm.pointee!.pointee.AttachCurrentThread(jvm, environment, nil)
    })
#endif
    guard result == JNI_OK else {
        throw JavaVirtualMachineError(fromJNIError: result)
    }
#if os(Android)
    return environment!
#else
    return environment!.assumingMemoryBound(to: JNIEnv?.self)
#endif
}

private func attachCurrentThreadAsDaemon(jvm: JavaVirtualMachinePointer) throws(JavaVirtualMachineError) -> JNIEnvironment {
#if os(Android)
    var environment: UnsafeMutablePointer<JNIEnv?>? = nil
    let result = withUnsafeMutablePointer(to: &environment, { environment in
        jvm.pointee!.pointee.AttachCurrentThreadAsDaemon(jvm, environment, nil)
    })
#else
    var environment: UnsafeMutableRawPointer? = nil
    let result = withUnsafeMutablePointer(to: &environment, { environment in
        jvm.pointee!.pointee.AttachCurrentThreadAsDaemon(jvm, environment, nil)
    })
#endif
    guard result == JNI_OK else {
        throw JavaVirtualMachineError(fromJNIError: result)
    }
#if os(Android)
    return environment!
#else
    return environment!.assumingMemoryBound(to: JNIEnv?.self)
#endif
}

private func detachCurrentThread(jvm: JavaVirtualMachinePointer) throws(JavaVirtualMachineError) {
    let result = jvm.pointee!.pointee.DetachCurrentThread(jvm)
    guard result == JNI_OK else {
        throw JavaVirtualMachineError(fromJNIError: result)
    }
}
