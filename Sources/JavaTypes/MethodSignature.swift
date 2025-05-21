/// Describes a Java method signature.
public struct MethodSignature: Equatable, Hashable {
    /// The result type of this method.
    public let resultType: JavaType
    
    /// The parameter types of this method.
    public let parameterTypes: [JavaType]
    
    public init(resultType: JavaType, parameterTypes: [JavaType]) {
        self.resultType = resultType
        self.parameterTypes = parameterTypes
    }
}
