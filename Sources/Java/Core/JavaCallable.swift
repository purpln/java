import JavaRuntime

public protocol JavaCallable: JavaRepresentable {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType>
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType>
}

public extension JavaCallable where JNIType == jboolean {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallBooleanMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticBooleanMethodA
    }
}

public extension JavaCallable where JNIType == jfloat {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallFloatMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticFloatMethodA
    }
}

public extension JavaCallable where JNIType == jdouble {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallDoubleMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticDoubleMethodA
    }
}

public extension JavaCallable where JNIType == jbyte {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallByteMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticByteMethodA
    }
}

public extension JavaCallable where JNIType == jchar {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallCharMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticCharMethodA
    }
}

public extension JavaCallable where JNIType == jshort {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallShortMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticShortMethodA
    }
}

public extension JavaCallable where JNIType == jint {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallIntMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticIntMethodA
    }
}

public extension JavaCallable where JNIType == jlong {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallLongMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticLongMethodA
    }
}

public extension JavaCallable where JNIType == jobject? {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallObjectMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticObjectMethodA
    }
}

public extension JavaCallable where JNIType == Void {
    static func jniMethodCall(in environment: JNIEnvironment) -> JNIMethodCall<JNIType> {
        environment.interface.CallVoidMethodA
    }
    
    static func jniStaticMethodCall(in environment: JNIEnvironment) -> JNIStaticMethodCall<JNIType> {
        environment.interface.CallStaticVoidMethodA
    }
}
