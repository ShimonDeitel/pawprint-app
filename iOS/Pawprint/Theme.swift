import SwiftUI

/// Unique visual identity for Pawprint.
enum Theme {
    static let background = Color(red: 0.071, green: 0.149, blue: 0.133)
    static let accent = Color(red: 0.247, green: 0.749, blue: 0.620)
    static let secondary = Color(red: 0.604, green: 0.839, blue: 0.776)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .default).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .default).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .default)
    static let captionFont = Font.system(.caption, design: .default)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
