import Foundation

/// Local product identity, independent of any release service or developer account.
enum AppIdentity {
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "local.pastory.app"
    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
}
