import JavaRuntime

#if os(Android)
public typealias NativeInterface = JNINativeInterface
#else
public typealias NativeInterface = JNINativeInterface_
#endif

public typealias JNIEnvironment = UnsafeMutablePointer<JNIEnv?>

public extension JNIEnvironment {
    var interface: NativeInterface { pointee!.pointee }
}
