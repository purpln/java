#if canImport(Darwin)
import Darwin
#elseif canImport(Bionic)
import Bionic
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(WinSDK)
import WinSDK
#endif

#if !(canImport(Darwin) || canImport(Bionic) || canImport(Glibc) || canImport(Musl) || canImport(WinSDK))
private var globalTlsValue: UnsafeMutableRawPointer?
#endif

package struct ThreadLocalStorage: ~Copyable {
#if canImport(Darwin) || canImport(Bionic) || canImport(Glibc) || canImport(Musl)
    private typealias PlatformKey = pthread_key_t
#elseif canImport(WinSDK)
    private typealias PlatformKey = DWORD
#else
    private typealias PlatformKey = Void
#endif
    
#if canImport(Darwin)
    package typealias Value = UnsafeMutableRawPointer
#else
    package typealias Value = UnsafeMutableRawPointer?
#endif
    
    package typealias OnThreadExit = @convention(c) (_: Value) -> ()
    
#if canImport(Darwin) || canImport(Bionic) || canImport(Glibc) || canImport(Musl)
    private var key: PlatformKey
#elseif canImport(WinSDK)
    private let key: PlatformKey
#endif
    
    package init(onThreadExit: OnThreadExit) {
#if canImport(Darwin) || canImport(Bionic) || canImport(Glibc) || canImport(Musl)
        key = 0
        pthread_key_create(&key, onThreadExit)
#elseif canImport(WinSDK)
        key = FlsAlloc(onThreadExit)
#endif
    }
    
    package func get() -> UnsafeMutableRawPointer? {
#if canImport(Darwin) || canImport(Bionic) || canImport(Glibc) || canImport(Musl)
        pthread_getspecific(key)
#elseif canImport(WinSDK)
        FlsGetValue(key)
#else
        globalTlsValue
#endif
    }
    
    package func set(_ value: Value) {
#if canImport(Darwin) || canImport(Bionic) || canImport(Glibc) || canImport(Musl)
        pthread_setspecific(key, value)
#elseif canImport(WinSDK)
        FlsSetValue(key, value)
#else
        globalTlsValue = value
#endif
    }
    
    deinit {
#if canImport(Darwin) || canImport(Bionic) || canImport(Glibc) || canImport(Musl)
        pthread_key_delete(key)
#elseif canImport(WinSDK)
        FlsFree(key)
#endif
    }
}
