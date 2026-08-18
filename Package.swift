// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "MasteryClock",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "MasteryClock", targets: ["MasteryClock"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MasteryClock",
            dependencies: [],
            path: "Sources/MasteryClock"
        )
  ]
)
