extension JNIEnvironment {
    func translatingExceptions<Result>(
        _ body: () throws -> Result
    ) throws -> Result {
        let result = try body()
        
        if let exception = interface.ExceptionOccurred(self) {
            interface.ExceptionClear(self)
            throw Throwable(this: exception, environment: self)
        }
        
        return result
    }
}
