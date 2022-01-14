// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let icAppArrowLeft = ImageAsset(name: "ic_app_arrow_left")
  internal static let icEmptyBasket = ImageAsset(name: "ic_empty_basket")
  internal static let icSelectedHeartPdf = ImageAsset(name: "ic_selected_heart_pdf")
  internal static let icUnselectedHeartPdf = ImageAsset(name: "ic_unselected_heart_pdf")
  internal static let icWhiteBasket = ImageAsset(name: "ic_white_basket")
  internal static let icAvatarPlaceholder = ImageAsset(name: "ic_avatar_placeholder")
  internal static let icEditProfile = ImageAsset(name: "ic_edit_profile")
  internal static let icArrowLeft = ImageAsset(name: "ic_arrow_left")
  internal static let icArrowRight = ImageAsset(name: "ic_arrow_right")
  internal static let icNetworkError = ImageAsset(name: "ic_network_error")
  internal static let icServerError = ImageAsset(name: "ic_server_error")
  internal static let icGreenMapPin = ImageAsset(name: "ic_green_map_pin")
  internal static let icMapPing = ImageAsset(name: "ic_map_ping")
  internal static let backgroundGray = ColorAsset(name: "backgroundGray")
  internal static let darkBlue = ColorAsset(name: "darkBlue")
  internal static let favouriteBtnBorder = ColorAsset(name: "favourite_btn_border")
  internal static let gray = ColorAsset(name: "gray")
  internal static let gray2 = ColorAsset(name: "gray2")
  internal static let grayLight = ColorAsset(name: "grayLight")
  internal static let light = ColorAsset(name: "light")
  internal static let mainBlack = ColorAsset(name: "mainBlack")
  internal static let mainBlue = ColorAsset(name: "mainBlue")
  internal static let mainGreen = ColorAsset(name: "mainGreen")
  internal static let mainRed = ColorAsset(name: "mainRed")
  internal static let mainWhite = ColorAsset(name: "mainWhite")
  internal static let notifIsViewed = ColorAsset(name: "notif_is_viewed")
  internal static let orange = ColorAsset(name: "orange")
  internal static let secondaryGray = ColorAsset(name: "secondaryGray")
  internal static let secondaryGray2 = ColorAsset(name: "secondaryGray2")
  internal static let secondaryGray3 = ColorAsset(name: "secondaryGray3")
  internal static let secondaryGrayLight = ColorAsset(name: "secondaryGrayLight")
  internal static let secondaryLight = ColorAsset(name: "secondaryLight")
  internal static let secondaryRed = ColorAsset(name: "secondaryRed")
  internal static let secondaryWhite = ColorAsset(name: "secondaryWhite")
  internal static let segmentControllBack = ColorAsset(name: "segment_controll_back")
  internal static let icEmptyFavourites = ImageAsset(name: "ic_empty_favourites")
  internal static let icAddress = ImageAsset(name: "ic_address")
  internal static let icEmail = ImageAsset(name: "ic_email")
  internal static let icPhone = ImageAsset(name: "ic_phone")
  internal static let icTopArrow = ImageAsset(name: "ic_top_arrow")
  internal static let icHomeDelivery = ImageAsset(name: "ic_home_delivery")
  internal static let icHomeMap = ImageAsset(name: "ic_home_map")
  internal static let icHomeOrder = ImageAsset(name: "ic_home_order")
  internal static let icCompanyOwner = ImageAsset(name: "ic_company_owner")
  internal static let icDrugMinus = ImageAsset(name: "ic_drug_minus")
  internal static let icDrugPlus = ImageAsset(name: "ic_drug_plus")
  internal static let icSearch = ImageAsset(name: "ic_ search")
  internal static let icNavBarLeftView = ImageAsset(name: "ic_nav_bar_left_view")
  internal static let icNotification = ImageAsset(name: "ic_notification")
  internal static let icLaunch = ImageAsset(name: "ic_launch")
  internal static let icAboutCompany = ImageAsset(name: "ic_about_company")
  internal static let icAppRule = ImageAsset(name: "ic_app_rule")
  internal static let icHelp = ImageAsset(name: "ic_help")
  internal static let icHistoryOfOrders = ImageAsset(name: "ic_history_of_orders")
  internal static let icLogoutAccount = ImageAsset(name: "ic_logout_account")
  internal static let icMyGoods = ImageAsset(name: "ic_my_goods")
  internal static let icOrderHistory = ImageAsset(name: "ic_order_history")
  internal static let icProfile = ImageAsset(name: "ic_profile")
  internal static let icProgramRules = ImageAsset(name: "ic_program_rules")
  internal static let icSignOut = ImageAsset(name: "ic_sign_out")
  internal static let icMyProductBasket = ImageAsset(name: "ic_my_product_basket")
  internal static let icEmptyNotifications = ImageAsset(name: "ic_empty_notifications")
  internal static let icNotViewedAccountApproved = ImageAsset(name: "ic_not_viewed_account_approved")
  internal static let icNotViewedAccountRejected = ImageAsset(name: "ic_not_viewed_account_rejected")
  internal static let icOrderDelivered = ImageAsset(name: "ic_order_delivered")
  internal static let icOrderProcessed = ImageAsset(name: "ic_order_processed")
  internal static let icViewedAccountApproved = ImageAsset(name: "ic_viewed_account_approved")
  internal static let icViewedAccountRejected = ImageAsset(name: "ic_viewed_account_rejected")
  internal static let icOb1 = ImageAsset(name: "ic_ob_1")
  internal static let icOb2 = ImageAsset(name: "ic_ob_2")
  internal static let icOb3 = ImageAsset(name: "ic_ob_3")
  internal static let icExpanded = ImageAsset(name: "ic_expanded")
  internal static let icShorten = ImageAsset(name: "ic_shorten")
  internal static let icCall = ImageAsset(name: "ic_call")
  internal static let icClose = ImageAsset(name: "ic_close")
  internal static let icDefaultDrug = ImageAsset(name: "ic_default_drug")
  internal static let icDelete = ImageAsset(name: "ic_delete")
  internal static let icImagePlaceholder = ImageAsset(name: "ic_image_placeholder")
  internal static let icMinus = ImageAsset(name: "ic_minus")
  internal static let icPlus = ImageAsset(name: "ic_plus")
  internal static let icProductEditButton = ImageAsset(name: "ic_product_edit_button")
  internal static let icSelectedBasket = ImageAsset(name: "ic_selected_basket")
  internal static let icSelectedHeart = ImageAsset(name: "ic_selected_heart")
  internal static let icUnselectedBasket = ImageAsset(name: "ic_unselected_basket")
  internal static let icUnselectedHeart = ImageAsset(name: "ic_unselected_heart")
  internal static let icUnselectedHeartWithBorder = ImageAsset(name: "ic_unselected_heart_with_border")
  internal static let icWithBackgroundCall = ImageAsset(name: "ic_with_background_call")
  internal static let icRegisterSuccess = ImageAsset(name: "ic_ register_success")
  internal static let icAddCertificate = ImageAsset(name: "ic_add_certificate")
  internal static let icAddImage = ImageAsset(name: "ic_add_image")
  internal static let icArrowDown = ImageAsset(name: "ic_arrow_down")
  internal static let icCamera = ImageAsset(name: "ic_camera")
  internal static let icRemove = ImageAsset(name: "ic_remove")
  internal static let icTrash = ImageAsset(name: "ic_trash")
  internal static let icActiveGrid = ImageAsset(name: "ic_active_grid")
  internal static let icNotActiveList = ImageAsset(name: "ic_not_active_list")
  internal static let icSearchResult = ImageAsset(name: "ic_search_result")
  internal static let icSelectedCart = ImageAsset(name: "ic_selected_cart")
  internal static let icSelectedCategories = ImageAsset(name: "ic_selected_categories")
  internal static let icSelectedFavorites = ImageAsset(name: "ic_selected_favorites")
  internal static let icSelectedHome = ImageAsset(name: "ic_selected_home")
  internal static let icSelectedMenu = ImageAsset(name: "ic_selected_menu")
  internal static let icUnselectedCart = ImageAsset(name: "ic_unselected_cart")
  internal static let icUnselectedCategories = ImageAsset(name: "ic_unselected_categories")
  internal static let icUnselectedFavorites = ImageAsset(name: "ic_unselected_favorites")
  internal static let icUnselectedHome = ImageAsset(name: "ic_unselected_home")
  internal static let icUnselectedMenu = ImageAsset(name: "ic_unselected_menu")
  internal static let icCalendar = ImageAsset(name: "ic_calendar")
  internal static let icCustomerOption = ImageAsset(name: "ic_customer_option")
  internal static let icSelectedCheckbox = ImageAsset(name: "ic_selected_checkbox")
  internal static let icSelectedRadioButton = ImageAsset(name: "ic_selected_radio_button")
  internal static let icSellerOption = ImageAsset(name: "ic_seller_option")
  internal static let icUnselectedCheckbox = ImageAsset(name: "ic_unselected_checkbox")
  internal static let icUnselectedRadioButton = ImageAsset(name: "ic_unselected_radio_button")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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
