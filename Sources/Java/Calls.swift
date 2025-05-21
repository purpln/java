import JavaRuntime
import JavaTypes

private func methodMangling<each Argument: JavaValue>(
    parameterTypes: repeat (each Argument).Type,
    resultType: JavaType
) -> String {
    var parameterTypesArray: [JavaType] = []
    for parameterType in repeat each parameterTypes {
        parameterTypesArray.append(parameterType.javaType)
    }
    return MethodSignature(
        resultType: resultType,
        parameterTypes: parameterTypesArray
    ).mangledName
}

private func countArguments<each Argument>(_ arguments: repeat each Argument) -> Int {
    var count = 0
    for _ in repeat each arguments {
        count += 1
    }
    return count
}

internal func getJValues<each Argument: JavaValue>(
    _ arguments: repeat each Argument,
    in environment: JNIEnvironment
) -> [jvalue] {
    [jvalue](unsafeUninitializedCapacity: countArguments(repeat each arguments)) { (buffer, count) in
        for argument in repeat each arguments {
            buffer[count] = argument.getJValue(in: environment)
            count += 1
        }
    }
}

private let javaConstructorName = "<init>"

typealias LookupFunction = (JNIEnvironment, jclass, UnsafePointer<CChar>, UnsafePointer<CChar>) -> jmethodID?

func lookup<each Argument: JavaValue>(
    this: jclass,
    method: String,
    parameterTypes: repeat (each Argument).Type,
    resultType: JavaType,
    with function: LookupFunction,
    in environment: JNIEnvironment
) throws -> jmethodID {
    let signature = methodMangling(
        parameterTypes: repeat (each Argument).self,
        resultType: resultType
    )
    
    return try environment.translatingExceptions {
        function(environment, this, method, signature)
    }!
}

func lookup<Result: JavaValue>(
    this: jclass,
    property: String,
    resultType: Result.Type,
    with function: LookupFunction,
    in environment: JNIEnvironment
) throws -> jmethodID {
    return try environment.translatingExceptions {
        function(environment, this, property, Result.javaType.mangledName)
    }!
}

extension JavaRepresentable {
    public init<each Argument: JavaValue>(
        in environment: JNIEnvironment,
        arguments: repeat each Argument
    ) throws {
        let object = try Self.withClass(in: environment, { thisClass in
            let methodID = try lookup(
                this: thisClass,
                method: javaConstructorName,
                parameterTypes: repeat (each Argument).self,
                resultType: .void,
                with: environment.interface.GetMethodID,
                in: environment
            )
            
            let jniArguments = getJValues(repeat each arguments, in: environment)
            return try environment.translatingExceptions {
                environment.interface.NewObjectA!(environment, thisClass, methodID, jniArguments)
            }!
        })
        self.init(this: object, environment: environment)
    }
    
    public func call<each Argument: JavaValue>(
        method: String,
        arguments: repeat each Argument
    ) throws {
        let thisClass = environment.interface.GetObjectClass(environment, this)!
        let methodID = try lookup(
            this: thisClass,
            method: method,
            parameterTypes: repeat (each Argument).self,
            resultType: .void,
            with: environment.interface.GetMethodID,
            in: environment
        )
        
        let jniMethod = environment.interface.CallVoidMethodA!
        let jniArguments = getJValues(repeat each arguments, in: environment)
        try environment.translatingExceptions {
            jniMethod(environment, this, methodID, jniArguments)
        }
    }
    
    public func call<each Argument: JavaValue, Result: JavaCallable>(
        method: String,
        arguments: repeat each Argument,
        result: Result.Type = Result.self
    ) throws -> Result {
        let thisClass = environment.interface.GetObjectClass(environment, this)!
        let methodID = try lookup(
            this: thisClass,
            method: method,
            parameterTypes: repeat (each Argument).self,
            resultType: Result.javaType,
            with: environment.interface.GetMethodID,
            in: environment
        )
        
        let jniMethod = Result.jniMethodCall(in: environment)
        let jniArguments = getJValues(repeat each arguments, in: environment)
        let jniResult = try environment.translatingExceptions {
            jniMethod(environment, this, methodID, jniArguments)
        }
        return Result(fromJNI: jniResult, in: environment)
    }
    
    public static func call<each Argument: JavaValue>(
        in environment: JNIEnvironment,
        method: String,
        arguments: repeat each Argument
    ) throws {
        try withClass(in: environment, { thisClass in
            let methodID = try lookup(
                this: thisClass,
                method: method,
                parameterTypes: repeat (each Argument).self,
                resultType: .void,
                with: environment.interface.GetStaticMethodID,
                in: environment
            )
            
            let jniMethod = environment.interface.CallStaticVoidMethodA!
            let jniArguments = getJValues(repeat each arguments, in: environment)
            try environment.translatingExceptions {
                jniMethod(environment, thisClass, methodID, jniArguments)
            }
        })
    }
    
    public static func call<each Argument: JavaValue, Result: JavaCallable>(
        in environment: JNIEnvironment,
        method: String,
        arguments: repeat each Argument,
        result: Result.Type = Result.self
    ) throws -> Result {
        try withClass(in: environment, { thisClass in
            let methodID = try lookup(
                this: thisClass,
                method: method,
                parameterTypes: repeat (each Argument).self,
                resultType: Result.javaType,
                with: environment.interface.GetStaticMethodID,
                in: environment
            )
            
            let jniMethod = Result.jniStaticMethodCall(in: environment)
            let jniArguments = getJValues(repeat each arguments, in: environment)
            let jniResult = try environment.translatingExceptions {
                jniMethod(environment, thisClass, methodID, jniArguments)
            }
            return Result(fromJNI: jniResult, in: environment)
        })
    }
    
    public subscript<Property: JavaStorable>(
        property: String,
        type: Property.Type = Property.self
    ) -> Property {
        get {
            let thisClass = environment.interface.GetObjectClass(environment, this)!
            let fieldID = try! lookup(
                this: thisClass,
                property: property,
                resultType: Property.self,
                with: environment.interface.GetFieldID,
                in: environment
            )
            
            let jniMethod = Property.jniFieldGet(in: environment)
            return Property(fromJNI: jniMethod(environment, this, fieldID), in: environment)
        }
        
        nonmutating set {
            let thisClass = environment.interface.GetObjectClass(environment, this)!
            let fieldID = try! lookup(
                this: thisClass,
                property: property,
                resultType: Property.self,
                with: environment.interface.GetFieldID,
                in: environment
            )
            
            let jniMethod = Property.jniFieldSet(in: environment)
            jniMethod(environment, this, fieldID, newValue.getJNIValue(in: environment))
        }
    }
    
    public static subscript<Property: JavaStorable>(
        environment: JNIEnvironment,
        property: String,
        type: Property.Type = Property.self
    ) -> Property {
        get {
            try! withClass(in: environment, { thisClass in
                let fieldID = try lookup(
                    this: thisClass,
                    property: property,
                    resultType: Property.self,
                    with: environment.interface.GetStaticFieldID,
                    in: environment
                )
                
                let jniMethod = Property.jniStaticFieldGet(in: environment)
                return Property(fromJNI: jniMethod(environment, thisClass, fieldID), in: environment)
            })
        }
        
        set {
            try! withClass(in: environment, { thisClass in
                let fieldID = try lookup(
                    this: thisClass,
                    property: property,
                    resultType: Property.self,
                    with: environment.interface.GetStaticFieldID,
                    in: environment
                )
                
                let jniMethod = Property.jniStaticFieldSet(in: environment)
                jniMethod(environment, thisClass, fieldID, newValue.getJNIValue(in: environment))
            })
        }
    }
}
