import JavaRuntime

public protocol JavaStorable: JavaRepresentable {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType>
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType>
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType>
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType>
}

public extension JavaStorable where JNIType == jboolean {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetBooleanField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetBooleanField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticBooleanField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticBooleanField
    }
}

public extension JavaStorable where JNIType == jfloat {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetFloatField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetFloatField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticFloatField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticFloatField
    }
}

public extension JavaStorable where JNIType == jdouble {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetDoubleField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetDoubleField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticDoubleField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticDoubleField
    }
}

public extension JavaStorable where JNIType == jbyte {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetByteField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetByteField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticByteField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticByteField
    }
}

public extension JavaStorable where JNIType == jchar {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetCharField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetCharField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticCharField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticCharField
    }
}

public extension JavaStorable where JNIType == jshort {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetShortField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetShortField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticShortField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticShortField
    }
}

public extension JavaStorable where JNIType == jint {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetIntField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetIntField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticIntField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticIntField
    }
}

public extension JavaStorable where JNIType == jlong {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetLongField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetLongField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticLongField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticLongField
    }
}

public extension JavaStorable where JNIType == jobject {
    static func jniFieldGet(in environment: JNIEnvironment) -> JNIFieldGet<JNIType> {
        environment.interface.GetObjectField
    }
    
    static func jniFieldSet(in environment: JNIEnvironment) -> JNIFieldSet<JNIType> {
        environment.interface.SetObjectField
    }
    
    static func jniStaticFieldGet(in environment: JNIEnvironment) -> JNIStaticFieldGet<JNIType> {
        environment.interface.GetStaticObjectField
    }
    
    static func jniStaticFieldSet(in environment: JNIEnvironment) -> JNIStaticFieldSet<JNIType> {
        environment.interface.SetStaticObjectField
    }
}
