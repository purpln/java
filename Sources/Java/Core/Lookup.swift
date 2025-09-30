import JavaRuntime
import JavaTypes

extension JNIEnvironment {
    func translatingExceptions<Result>(
        _ body: () -> Result?
    ) throws -> Result {
        guard let result = body() else {
            if let exception = interface.ExceptionOccurred(self) {
                interface.ExceptionClear(self)
                throw try Throwable(jni: exception, in: self)
            } else {
                fatalError("unexpected condition")
            }
        }
        return result
    }
}

public extension JavaIntractable {
    init<each Argument: JavaValue>(
        in environment: JNIEnvironment,
        arguments: repeat each Argument
    ) throws {
        let object = try Self.withClass(in: environment, { thisClass in
            let methodID = try lookup(
                this: thisClass,
                method: javaConstructorName,
                parameterTypes: repeat (each Argument).self,
                resultType: Lookup.self,
                with: environment.interface.GetMethodID,
                in: environment
            )
            
            let jniArguments = try getJValues(repeat each arguments, in: environment)
            return try environment.translatingExceptions {
                environment.interface.NewObjectA!(environment, thisClass, methodID, jniArguments)
            }!
        })
        let holder = try JavaReference(object: object, in: environment)
        self.init(holder: holder)
    }
}

public extension JavaIntractable {
    @_disfavoredOverload
    func call<each Argument: JavaValue, Result: JavaValue>(
        method: String,
        arguments: (repeat each Argument) = (),
        result: Result.Type = Result.self
    ) throws -> Result {
        let result = try call(method: method, arguments: (repeat each arguments), result: Result.self)
        return try Result(jni: result, in: environment)
    }
    
    func call<each Argument: JavaValue, Result: JavaCallable>(
        method: String,
        arguments: (repeat each Argument) = (),
        result: Result.Type = Lookup.self
    ) throws -> Result.JNIType {
        let thisClass = environment.interface.GetObjectClass(environment, this)!
        let methodID = try lookup(
            this: thisClass,
            method: method,
            parameterTypes: repeat (each Argument).self,
            resultType: Result.self,
            with: environment.interface.GetMethodID,
            in: environment
        )
        let jniMethod = Result.jniMethodCall(in: environment)
        let jniArguments = try getJValues(repeat each arguments, in: environment)
        let jniResult = try environment.translatingExceptions {
            jniMethod(environment, this, methodID, jniArguments)
        }
        return jniResult
    }
}

public extension JavaIntractable {
    @_disfavoredOverload
    static func call<each Argument: JavaValue, Result: JavaValue>(
        in environment: JNIEnvironment,
        method: String,
        arguments: (repeat each Argument) = (),
        result: Result.Type = Result.self
    ) throws -> Result {
        let result = try call(in: environment, method: method, arguments: (repeat each arguments), result: Result.self)
        return try Result(jni: result, in: environment)
    }
    
    static func call<each Argument: JavaValue, Result: JavaCallable>(
        in environment: JNIEnvironment,
        method: String,
        arguments: (repeat each Argument) = (),
        result: Result.Type = Lookup.self
    ) throws -> Result.JNIType {
        try withClass(in: environment, { thisClass in
            let methodID = try lookup(
                this: thisClass,
                method: method,
                parameterTypes: repeat (each Argument).self,
                resultType: Result.self,
                with: environment.interface.GetStaticMethodID,
                in: environment
            )
            
            let jniMethod = Result.jniStaticMethodCall(in: environment)
            let jniArguments = try getJValues(repeat each arguments, in: environment)
            let jniResult = try environment.translatingExceptions {
                jniMethod(environment, thisClass, methodID, jniArguments)
            }
            return jniResult
        })
    }
}

public extension JavaIntractable {
    subscript<Property: JavaValue>(
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
            return try! Property(jni: jniMethod(environment, this, fieldID)!, in: environment)
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
            jniMethod(environment, this, fieldID, try! newValue.jni(in: environment))
        }
    }
    
    static subscript<Property: JavaValue>(
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
                return try! Property(jni: jniMethod(environment, thisClass, fieldID)!, in: environment)
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
                jniMethod(environment, thisClass, fieldID, try! newValue.jni(in: environment))
            })
        }
    }
}

public struct Lookup: JavaCallable {}

private typealias LookupFunction = (JNIEnvironment, jclass, UnsafePointer<CChar>, UnsafePointer<CChar>) -> jmethodID?

private let javaConstructorName = "<init>"

private func lookup<each Argument: JavaRepresentable, Result: JavaRepresentable>(
    this: jclass,
    method: String,
    parameterTypes: repeat (each Argument).Type,
    resultType: Result.Type = Result.self,
    with function: LookupFunction,
    in environment: JNIEnvironment
) throws -> jmethodID {
    let signature = methodMangling(
        parameterTypes: repeat (each Argument).self,
        resultType: resultType
    )
    
    return try environment.translatingExceptions {
        function(environment, this, method, signature)
    }
}

private func lookup<Result: JavaStorable>(
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

private func methodMangling<each Argument: JavaRepresentable, Result: JavaRepresentable>(
    parameterTypes: repeat (each Argument).Type,
    resultType: Result.Type
) -> String {
    var parameterTypesArray: [JavaType] = []
    for parameterType in repeat each parameterTypes {
        parameterTypesArray.append(parameterType.javaType)
    }
    return MethodSignature(
        resultType: resultType.javaType,
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

private func getJValues<each Argument: JavaValue>(
    _ arguments: repeat each Argument,
    in environment: JNIEnvironment
) throws -> [jvalue] {
    try [jvalue](unsafeUninitializedCapacity: countArguments(repeat each arguments)) { (buffer, count) in
        for argument in repeat each arguments {
            buffer[count] = try argument.getJValue(in: environment)
            count += 1
        }
    }
}

private extension JavaValue {
    func getJValue(in environment: JNIEnvironment) throws -> jvalue {
        var result = jvalue()
        result[keyPath: Self.jvalueKeyPath] = try jni(in: environment)
        return result
    }
}
