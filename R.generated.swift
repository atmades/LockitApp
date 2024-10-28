//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import RswiftResources
import UIKit

private class BundleFinder {}
let R = _R(bundle: Bundle(for: BundleFinder.self))

struct _R: Sendable {
  let bundle: Foundation.Bundle
  var string: string { .init(bundle: bundle, preferredLanguages: nil, locale: nil) }
  var color: color { .init(bundle: bundle) }
  var image: image { .init(bundle: bundle) }
  var info: info { .init(bundle: bundle) }
  var entitlements: entitlements { .init() }
  var font: font { .init(bundle: bundle) }
  var file: file { .init(bundle: bundle) }
  var storyboard: storyboard { .init(bundle: bundle) }

  func string(bundle: Foundation.Bundle) -> string {
    .init(bundle: bundle, preferredLanguages: nil, locale: nil)
  }
  func string(locale: Foundation.Locale) -> string {
    .init(bundle: bundle, preferredLanguages: nil, locale: locale)
  }
  func string(preferredLanguages: [String], locale: Locale? = nil) -> string {
    .init(bundle: bundle, preferredLanguages: preferredLanguages, locale: locale)
  }
  func color(bundle: Foundation.Bundle) -> color {
    .init(bundle: bundle)
  }
  func image(bundle: Foundation.Bundle) -> image {
    .init(bundle: bundle)
  }
  func info(bundle: Foundation.Bundle) -> info {
    .init(bundle: bundle)
  }
  func font(bundle: Foundation.Bundle) -> font {
    .init(bundle: bundle)
  }
  func file(bundle: Foundation.Bundle) -> file {
    .init(bundle: bundle)
  }
  func storyboard(bundle: Foundation.Bundle) -> storyboard {
    .init(bundle: bundle)
  }
  func validate() throws {
    try self.font.validate()
    try self.storyboard.validate()
  }

  struct project {
    let developmentRegion = "en"
  }

  /// This `_R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    let bundle: Foundation.Bundle
    let preferredLanguages: [String]?
    let locale: Locale?
    var localizedString: localizedString { .init(source: .init(bundle: bundle, tableName: "LocalizedString", preferredLanguages: preferredLanguages, locale: locale)) }

    func localizedString(preferredLanguages: [String]) -> localizedString {
      .init(source: .init(bundle: bundle, tableName: "LocalizedString", preferredLanguages: preferredLanguages, locale: locale))
    }


    /// This `_R.string.localizedString` struct is generated, and contains static references to 15 localization keys.
    struct localizedString {
      let source: RswiftResources.StringResource.Source

      /// en translation: Отмена
      ///
      /// Key: Cancel
      ///
      /// Locales: en
      var cancel: RswiftResources.StringResource { .init(key: "Cancel", tableName: "LocalizedString", source: source, developmentValue: "Отмена", comment: nil) }

      /// en translation: Закрыть
      ///
      /// Key: Close
      ///
      /// Locales: en
      var close: RswiftResources.StringResource { .init(key: "Close", tableName: "LocalizedString", source: source, developmentValue: "Закрыть", comment: nil) }

      /// en translation: Подтвердить
      ///
      /// Key: Confirm
      ///
      /// Locales: en
      var confirm: RswiftResources.StringResource { .init(key: "Confirm", tableName: "LocalizedString", source: source, developmentValue: "Подтвердить", comment: nil) }

      /// en translation: Подтверждение
      ///
      /// Key: Confirmation
      ///
      /// Locales: en
      var confirmation: RswiftResources.StringResource { .init(key: "Confirmation", tableName: "LocalizedString", source: source, developmentValue: "Подтверждение", comment: nil) }

      /// en translation: Ошибка
      ///
      /// Key: Error
      ///
      /// Locales: en
      var error: RswiftResources.StringResource { .init(key: "Error", tableName: "LocalizedString", source: source, developmentValue: "Ошибка", comment: nil) }

      /// en translation: Ссылка на файл
      ///
      /// Key: InputPlaceholder
      ///
      /// Locales: en
      var inputPlaceholder: RswiftResources.StringResource { .init(key: "InputPlaceholder", tableName: "LocalizedString", source: source, developmentValue: "Ссылка на файл", comment: nil) }

      /// en translation: Уведомление
      ///
      /// Key: Notice
      ///
      /// Locales: en
      var notice: RswiftResources.StringResource { .init(key: "Notice", tableName: "LocalizedString", source: source, developmentValue: "Уведомление", comment: nil) }

      /// en translation: Biometry
      ///
      /// Key: biometry
      ///
      /// Locales: en
      var biometry: RswiftResources.StringResource { .init(key: "biometry", tableName: "LocalizedString", source: source, developmentValue: "Biometry", comment: nil) }

      /// en translation: Camera Trap
      ///
      /// Key: cameraTrap
      ///
      /// Locales: en
      var cameraTrap: RswiftResources.StringResource { .init(key: "cameraTrap", tableName: "LocalizedString", source: source, developmentValue: "Camera Trap", comment: nil) }

      /// en translation: Fake Passcode
      ///
      /// Key: fakePasscode
      ///
      /// Locales: en
      var fakePasscode: RswiftResources.StringResource { .init(key: "fakePasscode", tableName: "LocalizedString", source: source, developmentValue: "Fake Passcode", comment: nil) }

      /// en translation: Masking
      ///
      /// Key: masking
      ///
      /// Locales: en
      var masking: RswiftResources.StringResource { .init(key: "masking", tableName: "LocalizedString", source: source, developmentValue: "Masking", comment: nil) }

      /// en translation: Change passcode
      ///
      /// Key: originalPasscode
      ///
      /// Locales: en
      var originalPasscode: RswiftResources.StringResource { .init(key: "originalPasscode", tableName: "LocalizedString", source: source, developmentValue: "Change passcode", comment: nil) }

      /// en translation: Rate Us
      ///
      /// Key: rateUs
      ///
      /// Locales: en
      var rateUs: RswiftResources.StringResource { .init(key: "rateUs", tableName: "LocalizedString", source: source, developmentValue: "Rate Us", comment: nil) }

      /// en translation: Share App
      ///
      /// Key: shareApp
      ///
      /// Locales: en
      var shareApp: RswiftResources.StringResource { .init(key: "shareApp", tableName: "LocalizedString", source: source, developmentValue: "Share App", comment: nil) }

      /// en translation: Support
      ///
      /// Key: support
      ///
      /// Locales: en
      var support: RswiftResources.StringResource { .init(key: "support", tableName: "LocalizedString", source: source, developmentValue: "Support", comment: nil) }
    }
  }

  /// This `_R.color` struct is generated, and contains static references to 9 colors.
  struct color {
    let bundle: Foundation.Bundle

    /// Color `AccentColor`.
    var accentColor: RswiftResources.ColorResource { .init(name: "AccentColor", path: [], bundle: bundle) }

    /// Color `color_gray20`.
    var color_gray20: RswiftResources.ColorResource { .init(name: "color_gray20", path: [], bundle: bundle) }

    /// Color `color_gray40`.
    var color_gray40: RswiftResources.ColorResource { .init(name: "color_gray40", path: [], bundle: bundle) }

    /// Color `color_gray50`.
    var color_gray50: RswiftResources.ColorResource { .init(name: "color_gray50", path: [], bundle: bundle) }

    /// Color `color_gray80`.
    var color_gray80: RswiftResources.ColorResource { .init(name: "color_gray80", path: [], bundle: bundle) }

    /// Color `color_gray85`.
    var color_gray85: RswiftResources.ColorResource { .init(name: "color_gray85", path: [], bundle: bundle) }

    /// Color `color_gray90`.
    var color_gray90: RswiftResources.ColorResource { .init(name: "color_gray90", path: [], bundle: bundle) }

    /// Color `color_main`.
    var color_main: RswiftResources.ColorResource { .init(name: "color_main", path: [], bundle: bundle) }

    /// Color `color_red`.
    var color_red: RswiftResources.ColorResource { .init(name: "color_red", path: [], bundle: bundle) }
  }

  /// This `_R.image` struct is generated, and contains static references to 50 images.
  struct image {
    let bundle: Foundation.Bundle

    /// Image `contacts`.
    var contacts: RswiftResources.ImageResource { .init(name: "contacts", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `contactsOn`.
    var contactsOn: RswiftResources.ImageResource { .init(name: "contactsOn", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `files`.
    var files: RswiftResources.ImageResource { .init(name: "files", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `filesOn`.
    var filesOn: RswiftResources.ImageResource { .init(name: "filesOn", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `glow`.
    var glow: RswiftResources.ImageResource { .init(name: "glow", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_biometry`.
    var ic_biometry: RswiftResources.ImageResource { .init(name: "ic_biometry", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_call`.
    var ic_call: RswiftResources.ImageResource { .init(name: "ic_call", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_cameraTrap`.
    var ic_cameraTrap: RswiftResources.ImageResource { .init(name: "ic_cameraTrap", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_change_passcode`.
    var ic_change_passcode: RswiftResources.ImageResource { .init(name: "ic_change_passcode", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_contact`.
    var ic_contact: RswiftResources.ImageResource { .init(name: "ic_contact", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_copy`.
    var ic_copy: RswiftResources.ImageResource { .init(name: "ic_copy", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_email`.
    var ic_email: RswiftResources.ImageResource { .init(name: "ic_email", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_face_passcode`.
    var ic_face_passcode: RswiftResources.ImageResource { .init(name: "ic_face_passcode", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_file`.
    var ic_file: RswiftResources.ImageResource { .init(name: "ic_file", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_folder`.
    var ic_folder: RswiftResources.ImageResource { .init(name: "ic_folder", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_image`.
    var ic_image: RswiftResources.ImageResource { .init(name: "ic_image", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_masking`.
    var ic_masking: RswiftResources.ImageResource { .init(name: "ic_masking", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_more`.
    var ic_more: RswiftResources.ImageResource { .init(name: "ic_more", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_plus`.
    var ic_plus: RswiftResources.ImageResource { .init(name: "ic_plus", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_rateUs`.
    var ic_rateUs: RswiftResources.ImageResource { .init(name: "ic_rateUs", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_shareApp`.
    var ic_shareApp: RswiftResources.ImageResource { .init(name: "ic_shareApp", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_support`.
    var ic_support: RswiftResources.ImageResource { .init(name: "ic_support", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ic_video`.
    var ic_video: RswiftResources.ImageResource { .init(name: "ic_video", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_arrow12`.
    var ico_arrow12: RswiftResources.ImageResource { .init(name: "ico_arrow12", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_arrow13`.
    var ico_arrow13: RswiftResources.ImageResource { .init(name: "ico_arrow13", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_arrow_back`.
    var ico_arrow_back: RswiftResources.ImageResource { .init(name: "ico_arrow_back", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_arrow_right`.
    var ico_arrow_right: RswiftResources.ImageResource { .init(name: "ico_arrow_right", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_close`.
    var ico_close: RswiftResources.ImageResource { .init(name: "ico_close", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_edit`.
    var ico_edit: RswiftResources.ImageResource { .init(name: "ico_edit", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_save`.
    var ico_save: RswiftResources.ImageResource { .init(name: "ico_save", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_saveToBook`.
    var ico_saveToBook: RswiftResources.ImageResource { .init(name: "ico_saveToBook", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `ico_share`.
    var ico_share: RswiftResources.ImageResource { .init(name: "ico_share", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `mask_calculator_normal`.
    var mask_calculator_normal: RswiftResources.ImageResource { .init(name: "mask_calculator_normal", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `mask_calculator_selcted`.
    var mask_calculator_selcted: RswiftResources.ImageResource { .init(name: "mask_calculator_selcted", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `mask_no_normal`.
    var mask_no_normal: RswiftResources.ImageResource { .init(name: "mask_no_normal", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `mask_no_selected`.
    var mask_no_selected: RswiftResources.ImageResource { .init(name: "mask_no_selected", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_android`.
    var masking_appIcon_android: RswiftResources.ImageResource { .init(name: "masking_appIcon_android", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_android_selected`.
    var masking_appIcon_android_selected: RswiftResources.ImageResource { .init(name: "masking_appIcon_android_selected", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_default`.
    var masking_appIcon_default: RswiftResources.ImageResource { .init(name: "masking_appIcon_default", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_default_selected`.
    var masking_appIcon_default_selected: RswiftResources.ImageResource { .init(name: "masking_appIcon_default_selected", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_defend`.
    var masking_appIcon_defend: RswiftResources.ImageResource { .init(name: "masking_appIcon_defend", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_defend_selected`.
    var masking_appIcon_defend_selected: RswiftResources.ImageResource { .init(name: "masking_appIcon_defend_selected", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_key`.
    var masking_appIcon_key: RswiftResources.ImageResource { .init(name: "masking_appIcon_key", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_key_selected`.
    var masking_appIcon_key_selected: RswiftResources.ImageResource { .init(name: "masking_appIcon_key_selected", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_lock`.
    var masking_appIcon_lock: RswiftResources.ImageResource { .init(name: "masking_appIcon_lock", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `masking_appIcon_lock_selected`.
    var masking_appIcon_lock_selected: RswiftResources.ImageResource { .init(name: "masking_appIcon_lock_selected", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `notes`.
    var notes: RswiftResources.ImageResource { .init(name: "notes", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `notesOn`.
    var notesOn: RswiftResources.ImageResource { .init(name: "notesOn", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `settings`.
    var settings: RswiftResources.ImageResource { .init(name: "settings", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `settingsOn`.
    var settingsOn: RswiftResources.ImageResource { .init(name: "settingsOn", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }
  }

  /// This `_R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    let bundle: Foundation.Bundle
    var uiApplicationSceneManifest: uiApplicationSceneManifest { .init(bundle: bundle) }

    func uiApplicationSceneManifest(bundle: Foundation.Bundle) -> uiApplicationSceneManifest {
      .init(bundle: bundle)
    }

    struct uiApplicationSceneManifest {
      let bundle: Foundation.Bundle

      let uiApplicationSupportsMultipleScenes: Bool = false

      var _key: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest"], key: "_key") ?? "UIApplicationSceneManifest" }
      var uiSceneConfigurations: uiSceneConfigurations { .init(bundle: bundle) }

      func uiSceneConfigurations(bundle: Foundation.Bundle) -> uiSceneConfigurations {
        .init(bundle: bundle)
      }

      struct uiSceneConfigurations {
        let bundle: Foundation.Bundle
        var _key: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest", "UISceneConfigurations"], key: "_key") ?? "UISceneConfigurations" }
        var uiWindowSceneSessionRoleApplication: uiWindowSceneSessionRoleApplication { .init(bundle: bundle) }

        func uiWindowSceneSessionRoleApplication(bundle: Foundation.Bundle) -> uiWindowSceneSessionRoleApplication {
          .init(bundle: bundle)
        }

        struct uiWindowSceneSessionRoleApplication {
          let bundle: Foundation.Bundle
          var defaultConfiguration: defaultConfiguration { .init(bundle: bundle) }

          func defaultConfiguration(bundle: Foundation.Bundle) -> defaultConfiguration {
            .init(bundle: bundle)
          }

          struct defaultConfiguration {
            let bundle: Foundation.Bundle
            var uiSceneConfigurationName: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication"], key: "UISceneConfigurationName") ?? "Default Configuration" }
            var uiSceneDelegateClassName: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate" }
          }
        }
      }
    }
  }

  /// This `_R.entitlements` struct is generated, and contains static references to 2 properties.
  struct entitlements {
    let comAppleDeveloperNetworkingSlicingAppcategory = comAppleDeveloperNetworkingSlicingAppcategory()
    let comAppleDeveloperNetworkingSlicingTrafficcategory = comAppleDeveloperNetworkingSlicingTrafficcategory()
    struct comAppleDeveloperNetworkingSlicingAppcategory {
      let communication9000: String = "communication-9000"
    }
    struct comAppleDeveloperNetworkingSlicingTrafficcategory {
      let callsignaling5: String = "callsignaling-5"
    }
  }

  /// This `_R.font` struct is generated, and contains static references to 6 fonts.
  struct font: Sequence {
    let bundle: Foundation.Bundle

    /// Font `AvenirNextCyr-Bold`.
    var avenirNextCyrBold: RswiftResources.FontResource { .init(name: "AvenirNextCyr-Bold", bundle: bundle, filename: "AvenirNextCyr-Bold.ttf") }

    /// Font `AvenirNextCyr-Demi`.
    var avenirNextCyrDemi: RswiftResources.FontResource { .init(name: "AvenirNextCyr-Demi", bundle: bundle, filename: "AvenirNextCyr-Demi.ttf") }

    /// Font `AvenirNextCyr-Light`.
    var avenirNextCyrLight: RswiftResources.FontResource { .init(name: "AvenirNextCyr-Light", bundle: bundle, filename: "AvenirNextCyr-Light.ttf") }

    /// Font `AvenirNextCyr-Medium`.
    var avenirNextCyrMedium: RswiftResources.FontResource { .init(name: "AvenirNextCyr-Medium", bundle: bundle, filename: "AvenirNextCyr-Medium.ttf") }

    /// Font `AvenirNextCyr-Regular`.
    var avenirNextCyrRegular: RswiftResources.FontResource { .init(name: "AvenirNextCyr-Regular", bundle: bundle, filename: "AvenirNextCyr-Regular.ttf") }

    /// Font `AvenirNextCyr-Thin`.
    var avenirNextCyrThin: RswiftResources.FontResource { .init(name: "AvenirNextCyr-Thin", bundle: bundle, filename: "AvenirNextCyr-Thin.ttf") }

    func makeIterator() -> IndexingIterator<[RswiftResources.FontResource]> {
      [avenirNextCyrBold, avenirNextCyrDemi, avenirNextCyrLight, avenirNextCyrMedium, avenirNextCyrRegular, avenirNextCyrThin].makeIterator()
    }
    func validate() throws {
      for font in self {
        if !font.canBeLoaded() { throw RswiftResources.ValidationError("[R.swift] Font '\(font.name)' could not be loaded, is '\(font.filename)' added to the UIAppFonts array in this targets Info.plist?") }
      }
    }
  }

  /// This `_R.file` struct is generated, and contains static references to 6 resource files.
  struct file {
    let bundle: Foundation.Bundle

    /// Resource file `AvenirNextCyr-Bold.ttf`.
    var avenirNextCyrBoldTtf: RswiftResources.FileResource { .init(name: "AvenirNextCyr-Bold", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `AvenirNextCyr-Demi.ttf`.
    var avenirNextCyrDemiTtf: RswiftResources.FileResource { .init(name: "AvenirNextCyr-Demi", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `AvenirNextCyr-Light.ttf`.
    var avenirNextCyrLightTtf: RswiftResources.FileResource { .init(name: "AvenirNextCyr-Light", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `AvenirNextCyr-Medium.ttf`.
    var avenirNextCyrMediumTtf: RswiftResources.FileResource { .init(name: "AvenirNextCyr-Medium", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `AvenirNextCyr-Regular.ttf`.
    var avenirNextCyrRegularTtf: RswiftResources.FileResource { .init(name: "AvenirNextCyr-Regular", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `AvenirNextCyr-Thin.ttf`.
    var avenirNextCyrThinTtf: RswiftResources.FileResource { .init(name: "AvenirNextCyr-Thin", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }
  }

  /// This `_R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    let bundle: Foundation.Bundle
    var launchScreen: launchScreen { .init(bundle: bundle) }
    var main: main { .init(bundle: bundle) }

    func launchScreen(bundle: Foundation.Bundle) -> launchScreen {
      .init(bundle: bundle)
    }
    func main(bundle: Foundation.Bundle) -> main {
      .init(bundle: bundle)
    }
    func validate() throws {
      try self.launchScreen.validate()
      try self.main.validate()
    }


    /// Storyboard `LaunchScreen`.
    struct launchScreen: RswiftResources.StoryboardReference, RswiftResources.InitialControllerContainer {
      typealias InitialController = UIKit.UIViewController

      let bundle: Foundation.Bundle

      let name = "LaunchScreen"
      func validate() throws {

      }
    }

    /// Storyboard `Main`.
    struct main: RswiftResources.StoryboardReference, RswiftResources.InitialControllerContainer {
      typealias InitialController = ViewController

      let bundle: Foundation.Bundle

      let name = "Main"
      func validate() throws {

      }
    }
  }
}