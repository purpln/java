/// Describes an error that can occur when demangling a Java name.
enum JavaDemanglingError: Error {
    /// This does not match the form of a Java mangled type name.
    case invalidMangledName(String)
    
    /// Extra text after the mangled name.
    case extraText(String)
}
