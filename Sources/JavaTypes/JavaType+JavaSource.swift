extension JavaType {
    /// Form a Java type based on the name that is produced by
    /// java.lang.Class.getName(). This can be primitive types like "int",
    /// class types like "java.lang.String", or arrays thereof.
    public init(javaTypeName: String) throws {
        switch javaTypeName {
        case "boolean": self = .boolean
        case "byte": self = .byte
        case "char": self = .char
        case "short": self = .short
        case "int": self = .int
        case "long": self = .long
        case "float": self = .float
        case "double": self = .double
        case "void": self = .void
            
        case let name where name.starts(with: "["):
            self = try JavaType(mangledName: name)
            
        case let className:
            self = JavaType(className: className)
        }
    }
}

extension JavaType: CustomStringConvertible {
    /// Description of the Java type as it would appear in Java source.
    public var description: String {
        switch self {
        case .boolean: "boolean"
        case .byte: "byte"
        case .char: "char"
        case .short: "short"
        case .int: "int"
        case .long: "long"
        case .float: "float"
        case .double: "double"
        case .void: "void"
        case .array(let elementType): "\(elementType.description)[]"
        case .class(package: let package, name: let name):
            if let package {
                "\(package).\(name)"
            } else {
                name
            }
        }
    }
    
    public var className: String {
        let name: String = {
            switch self {
            case .boolean:
                "java.lang.Boolean"
            case .byte:
                "java.lang.Byte" //java.lang.Number
            case .char:
                "java.lang.Character"
            case .short:
                "java.lang.Short" //java.lang.Number
            case .int:
                "java.lang.Integer" //java.lang.Number
            case .long:
                "java.lang.Long" //java.lang.Number
            case .float:
                "java.lang.Float" //java.lang.Number
            case .double:
                "java.lang.Double" //java.lang.Number
            case .void:
                "java.lang.Void"
            case .class(let package, let name):
                if let package {
                    "\(package).\(name)"
                } else {
                    name
                }
            case .array:
                "java.util.Arrays"
            }
        }()
        
        return name.replacingPeriodsWithSlashes()
    }
}
