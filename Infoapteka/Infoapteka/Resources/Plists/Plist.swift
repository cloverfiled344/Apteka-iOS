// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length type_body_length
internal enum PlistFiles {
  internal enum Api {
    private static let _document = PlistDocument(path: "Api.plist")
    internal static let account: String = _document["account"]
    internal static let accountCertificate: String = _document["account-certificate"]
    internal static let accountData: String = _document["account-data"]
    internal static let accountFavorite: String = _document["account-favorite"]
    internal static let accountLoginConfirm: String = _document["account-login-confirm"]
    internal static let api: String = _document["api"]
    internal static let cart: String = _document["cart"]
    internal static let checkUser: String = _document["check-user"]
    internal static let createDrug: String = _document["create-drug"]
    internal static let createDrugImage: String = _document["create-drug-image"]
    internal static let customerUserUpdate: String = _document["customer-user-update"]
    internal static let domen: String = _document["domen"]
    internal static let drug: String = _document["drug"]
    internal static let drugCategories: String = _document["drug-categories"]
    internal static let drugList: String = _document["drug-list"]
    internal static let drugSearchHint: String = _document["drug-search-hint"]
    internal static let drugSeller: String = _document["drug-seller"]
    internal static let elsomPayment: String = _document["elsom_payment"]
    internal static let info: String = _document["info"]
    internal static let infoBanner: String = _document["info-banner"]
    internal static let login: String = _document["login"]
    internal static let notification: String = _document["notification"]
    internal static let order: String = _document["order"]
    internal static let sellerUserRegistration: String = _document["seller-user-registration"]
    internal static let sellerUserUpdate: String = _document["seller-user-update"]
    internal static let settingCities: String = _document["setting-cities"]
    internal static let settingDistricts: String = _document["setting-districts"]
    internal static let settingVersion: String = _document["setting-version"]
    internal static let simpleUserRegistration: String = _document["simple-user-registration"]
    internal static let userAvatarDelete: String = _document["user-avatar-delete"]
    internal static let userAvatarUpdate: String = _document["user-avatar-update"]
    internal static let version: String = _document["version"]
  }
  internal enum GoogleServiceInfo {
    private static let _document = PlistDocument(path: "GoogleService-Info.plist")
    internal static let androidClientId: String = _document["ANDROID_CLIENT_ID"]
    internal static let apiKey: String = _document["API_KEY"]
    internal static let bundleId: String = _document["BUNDLE_ID"]
    internal static let clientId: String = _document["CLIENT_ID"]
    internal static let gcmSenderId: String = _document["GCM_SENDER_ID"]
    internal static let googleAppId: String = _document["GOOGLE_APP_ID"]
    internal static let isAdsEnabled: Bool = _document["IS_ADS_ENABLED"]
    internal static let isAnalyticsEnabled: Bool = _document["IS_ANALYTICS_ENABLED"]
    internal static let isAppinviteEnabled: Bool = _document["IS_APPINVITE_ENABLED"]
    internal static let isGcmEnabled: Bool = _document["IS_GCM_ENABLED"]
    internal static let isSigninEnabled: Bool = _document["IS_SIGNIN_ENABLED"]
    internal static let plistVersion: String = _document["PLIST_VERSION"]
    internal static let projectId: String = _document["PROJECT_ID"]
    internal static let reversedClientId: String = _document["REVERSED_CLIENT_ID"]
    internal static let storageBucket: String = _document["STORAGE_BUCKET"]
  }
  internal enum Info {
    private static let _document = PlistDocument(path: "Info.plist")
    internal static let cfBundleDevelopmentRegion: String = _document["CFBundleDevelopmentRegion"]
    internal static let cfBundleDisplayName: String = _document["CFBundleDisplayName"]
    internal static let cfBundleExecutable: String = _document["CFBundleExecutable"]
    internal static let cfBundleIdentifier: String = _document["CFBundleIdentifier"]
    internal static let cfBundleInfoDictionaryVersion: String = _document["CFBundleInfoDictionaryVersion"]
    internal static let cfBundleName: String = _document["CFBundleName"]
    internal static let cfBundlePackageType: String = _document["CFBundlePackageType"]
    internal static let cfBundleShortVersionString: String = _document["CFBundleShortVersionString"]
    internal static let cfBundleURLTypes: [[String: Any]] = _document["CFBundleURLTypes"]
    internal static let cfBundleVersion: String = _document["CFBundleVersion"]
    internal static let lsRequiresIPhoneOS: Bool = _document["LSRequiresIPhoneOS"]
    internal static let nsAppTransportSecurity: [String: Any] = _document["NSAppTransportSecurity"]
    internal static let nsCameraUsageDescription: String = _document["NSCameraUsageDescription"]
    internal static let nsLocationWhenInUseUsageDescription: String = _document["NSLocationWhenInUseUsageDescription"]
    internal static let nsPhotoLibraryUsageDescription: String = _document["NSPhotoLibraryUsageDescription"]
    internal static let uiAppFonts: [String] = _document["UIAppFonts"]
    internal static let uiApplicationSceneManifest: [String: Any] = _document["UIApplicationSceneManifest"]
    internal static let uiApplicationSupportsIndirectInputEvents: Bool = _document["UIApplicationSupportsIndirectInputEvents"]
    internal static let uiBackgroundModes: [String] = _document["UIBackgroundModes"]
    internal static let uiLaunchStoryboardName: String = _document["UILaunchStoryboardName"]
    internal static let uiRequiredDeviceCapabilities: [String] = _document["UIRequiredDeviceCapabilities"]
    internal static let uiSupportedInterfaceOrientations: [String] = _document["UISupportedInterfaceOrientations"]
    internal static let uiSupportedInterfaceOrientationsIpad: [String] = _document["UISupportedInterfaceOrientations~ipad"]
    internal static let uiUserInterfaceStyle: String = _document["UIUserInterfaceStyle"]
    internal static let uiViewControllerBasedStatusBarAppearance: Bool = _document["UIViewControllerBasedStatusBarAppearance"]
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func arrayFromPlist<T>(at path: String) -> [T] {
  guard let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
    let data = NSArray(contentsOf: url) as? [T] else {
    fatalError("Unable to load PLIST at path: \(path)")
  }
  return data
}

private struct PlistDocument {
  let data: [String: Any]

  init(path: String) {
    guard let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
      let data = NSDictionary(contentsOf: url) as? [String: Any] else {
        fatalError("Unable to load PLIST at path: \(path)")
    }
    self.data = data
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
