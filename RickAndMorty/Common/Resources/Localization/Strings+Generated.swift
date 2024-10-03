// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localize {
  /// Unexpected error (bad response). Please contact the system admin.
  internal static let badResponse = Localize.tr("Localizable", "badResponse", fallback: "Unexpected error (bad response). Please contact the system admin.")
  /// Canceled successfully.
  internal static let canceledSuccessfullyTitleLabel = Localize.tr("Localizable", "canceledSuccessfullyTitleLabel", fallback: "Canceled successfully.")
  /// Characters
  internal static let characters = Localize.tr("Localizable", "characters", fallback: "Characters")
  /// Error
  internal static let error = Localize.tr("Localizable", "error", fallback: "Error")
  /// There was an error communicating with the servers.
  internal static let failedToCommunicateWithServer = Localize.tr("Localizable", "failedToCommunicateWithServer", fallback: "There was an error communicating with the servers.")
  /// Unexpected error (403). Please contact the system admin.
  internal static let forbidden = Localize.tr("Localizable", "forbidden", fallback: "Unexpected error (403). Please contact the system admin.")
  /// There was a problem reaching the servers. Please contact the system admin.
  internal static let internalServerError = Localize.tr("Localizable", "internalServerError", fallback: "There was a problem reaching the servers. Please contact the system admin.")
  /// Localizable.strings
  ///  //  RickAndMorty
  ///  //
  ///  //  Created by Ahmad on 30/09/2024.
  ///  //
  internal static let loginTitle = Localize.tr("Localizable", "loginTitle", fallback: "Login")
  /// Unexpected error (404). Please contact the system admin.
  internal static let notFound = Localize.tr("Localizable", "notFound", fallback: "Unexpected error (404). Please contact the system admin.")
  /// The Internet connection appears to be offline.
  internal static let offline = Localize.tr("Localizable", "offline", fallback: "The Internet connection appears to be offline.")
  /// OK
  internal static let ok = Localize.tr("Localizable", "ok", fallback: "OK")
  /// There was a problem reaching the server. Please try again later.
  internal static let server = Localize.tr("Localizable", "server", fallback: "There was a problem reaching the server. Please try again later.")
  /// Request timed out. Please try again later.
  internal static let timedOut = Localize.tr("Localizable", "timedOut", fallback: "Request timed out. Please try again later.")
  internal enum Config {
    internal enum User {
      /// Change Password
      internal static let changePassword = Localize.tr("Localizable", "config.user.change_password", fallback: "Change Password")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localize {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
