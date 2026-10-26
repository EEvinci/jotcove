import Foundation

/// Local product identity, independent of any release service or developer account.
enum AppIdentity {
    static let name = "JotCove"
    static var displayName: String { L.isEnglish ? name : "笺湾" }
    // Stable identity keeps existing preferences and clipboard history available after renaming.
    static let legacyProductName = "Pastory"
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "local.pastory.app"
    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
}
