import JavaRuntime

public protocol JavaSequence: JavaRepresentable {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType>
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType>
}

public extension JavaSequence where JNIType == jboolean {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewBooleanArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetBooleanArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetBooleanArrayRegion
    }
}

public extension JavaSequence where JNIType == jfloat {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewFloatArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetFloatArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetFloatArrayRegion
    }
}

public extension JavaSequence where JNIType == jdouble {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewDoubleArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetDoubleArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetDoubleArrayRegion
    }
}

public extension JavaSequence where JNIType == jbyte {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewByteArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetByteArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetByteArrayRegion
    }
}

public extension JavaSequence where JNIType == jchar {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewCharArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetCharArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetCharArrayRegion
    }
}

public extension JavaSequence where JNIType == jshort {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewShortArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetShortArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetShortArrayRegion
    }
}

public extension JavaSequence where JNIType == jint {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewIntArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetIntArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetIntArrayRegion
    }
}

public extension JavaSequence where JNIType == jlong {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        environment.interface.NewLongArray
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        environment.interface.GetLongArrayRegion
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        environment.interface.SetLongArrayRegion
    }
}

public extension JavaSequence where JNIType == jobject? {
    static func jniNewArray(in environment: JNIEnvironment) -> JNINewArray {
        return { environment, size in
            try! withClass(in: environment) { jniClass in
                environment.interface.NewObjectArray(environment, size, jniClass, nil)
            }
        }
    }
    
    static func jniGetArrayRegion(in environment: JNIEnvironment) -> JNIGetArrayRegion<JNIType> {
        return { environment, array, start, length, outPointer in
            let buffer = UnsafeMutableBufferPointer(start: outPointer, count: Int(length))
            for i in start..<start + length {
                buffer.initializeElement(
                    at: Int(i),
                    to: environment.interface.GetObjectArrayElement(environment, array, CInt(i))!
                )
            }
        }
    }
    
    static func jniSetArrayRegion(in environment: JNIEnvironment) -> JNISetArrayRegion<JNIType> {
        return { environment, array, start, length, outPointer in
            let buffer = UnsafeBufferPointer(start: outPointer, count: Int(length))
            for i in start..<start + length {
                environment.interface.SetObjectArrayElement(environment, array, i, buffer[Int(i)])
            }
        }
    }
}
