// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "JotCove",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "JotCove",
            path: "Sources/JotCove",
            swiftSettings: [.swiftLanguageMode(.v5)],
            linkerSettings: [.linkedLibrary("sqlite3")]
        )
    ]
)
