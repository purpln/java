import JavaRuntime

#if !os(Android)
public typealias JNINativeInterface = JNINativeInterface_
#endif

public typealias JNIEnvironment = UnsafeMutablePointer<JNIEnv?>

public extension JNIEnvironment {
    var interface: JNINativeInterface { self.pointee!.pointee }
}
