// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Localizable.strings
  ///   KiwiPublicPod
  /// 
  ///   Created by 笔尚文化 on 2025/10/14.
  ///   Copyright © 2025 CocoaPods. All rights reserved.
  internal static var month: String { return L10n.tr("Localizable", "Month", fallback: "Month") }
  /// Report
  internal static var report: String { return L10n.tr("Localizable", "Report", fallback: "Report") }
  /// Year
  internal static var year: String { return L10n.tr("Localizable", "Year", fallback: "Year") }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = Localize_Swift_bridge(forKey:table:fallbackValue:)(key, table, value)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
