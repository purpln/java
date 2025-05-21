import JavaRuntime

/// Describes the kinds of errors that can occur when interacting with JNI.
public enum JavaVirtualMachineError: Error {
    /// There is already a Java Virtual Machine.
    case existingVM
    
    /// JNI version mismatch error.
    case jniVersion
    
    /// Thread is detached from the VM.
    case threadDetached
    
    /// Out of memory.
    case outOfMemory
    
    /// Invalid arguments.
    case invalidArguments
    
    /// Unknown JNI error.
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
