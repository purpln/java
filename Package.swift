// swift-tools-version: 6.0

import PackageDescription

#if ANDROID
let package = Package(name: "Java", products: [
    .library(name: "Java", targets: ["Java"]),
], targets: [
    .target(name: "Java", dependencies: [
        "JavaRuntime",
        "JavaTypes",
    ]),
    .target(name: "JavaRuntime"),
    .target(name: "JavaTypes"),
])
#else
func findJavaHome() -> String {
    if let home = Context.environment["JAVA_HOME"] {
        return home
    }
    
    // This is a workaround for envs (some IDEs) which have trouble with
    // picking up env variables during the build process
    if let home = Context.environment["HOME"],
       let path = try? String(contentsOfFile: "\(home)/.java_home", encoding: .utf8).split(separator: "\n").first {
        return String(path)
    }
    
    preconditionFailure("Please set the JAVA_HOME environment variable to point to where Java is installed.")
}
let javaHome = findJavaHome()

let javaIncludePath = "\(javaHome)/include"
#if os(Linux)
let javaPlatformIncludePath = "\(javaIncludePath)/linux"
#elseif os(macOS)
let javaPlatformIncludePath = "\(javaIncludePath)/darwin"
#elseif os(Windows)
let javaPlatformIncludePath = "\(javaIncludePath)/win32"
#endif

let package = Package(name: "Java", products: [
    .library(name: "Java", targets: ["Java"]),
], targets: [
    .target(name: "Java", dependencies: [
        "JavaRuntime",
        "JavaTypes",
    ], swiftSettings: [
        .unsafeFlags(["-I\(javaIncludePath)/", "-I\(javaPlatformIncludePath)/"]),
    ], linkerSettings: [
        .unsafeFlags([
            "-L\(javaHome)/lib/server",
            "-Xlinker", "-rpath",
            "-Xlinker", "\(javaHome)/lib/server",
        ], .when(platforms: [.linux, .macOS])),
        .unsafeFlags([
            "-L\(javaHome)/lib"
        ], .when(platforms: [.windows])),
        .linkedLibrary("jvm"),
    ]),
    .target(name: "JavaRuntime", swiftSettings: [
        .unsafeFlags(["-I\(javaIncludePath)/", "-I\(javaPlatformIncludePath)/"]),
    ]),
    .target(name: "JavaTypes"),
])
#endif
