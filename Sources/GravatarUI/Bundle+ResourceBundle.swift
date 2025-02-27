import Foundation

#if !SWIFT_PACKAGE
private class BundleFinder: NSObject {}
extension Bundle {
    static var module: Bundle {
        let defaultBundle = Bundle(for: BundleFinder.self)
        // If installed with CocoaPods, resources will be in GravatarUI.bundle
        if let bundleURL = defaultBundle.resourceURL,
           let resourceBundle = Bundle(url: bundleURL.appendingPathComponent("GravatarUI.bundle"))
        {
            return resourceBundle
        }
        // Otherwise, the default bundle is used for resources
        return defaultBundle
    }
}
#endif
