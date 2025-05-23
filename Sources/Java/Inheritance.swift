import JavaRuntime

extension JavaRepresentable {
    private func isInstanceOf<OtherClass: JavaRepresentable>(
        _ otherClass: OtherClass.Type
    ) -> jclass? {
        try? OtherClass.withClass(in: environment) { other in
            guard environment.interface.IsInstanceOf(environment, this, other) != 0 else { return nil }
            
            return other
        }
    }
    
    public func `is`<OtherClass: JavaRepresentable>(_ otherClass: OtherClass.Type) -> Bool {
        return isInstanceOf(otherClass) != nil
    }
    
    public func `as`<OtherClass: JavaRepresentable>(_ otherClass: OtherClass.Type) -> OtherClass? {
        guard `is`(otherClass) else { return nil }
        
        return OtherClass(holder: holder)
    }
}
