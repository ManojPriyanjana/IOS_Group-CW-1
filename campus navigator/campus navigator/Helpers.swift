// File: Helpers.swift

import SwiftUI

// MARK: - 1) Shared Color Extensions

extension Color {
    /// A custom purple accent (feel free to tweak the RGB values to your exact design).
    static var purpleAccent: Color {
        Color(red: 20/255, green: 69/255, blue: 203/255)
    }

    /// Background color for any “search field” or “search bar” container.
    /// Adapts automatically in Light vs Dark Mode.
    static var searchFieldBackground: Color {
        Color(UIColor { trait in
            return trait.userInterfaceStyle == .dark
                ? UIColor.systemGray6   // slightly darker in Dark
                : UIColor.systemGray5   // default in Light
        })
    }

    /// Border color for search fields (uses the system separator color).
    static var searchFieldBorder: Color {
        Color(UIColor.separator)
    }
}

// MARK: - 2) Corner Rounding for Specific Corners

/// A Shape that allows you to round only specified corners (e.g. topLeft, bottomRight, etc.).
struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Color {
    /// Initialize a SwiftUI Color from a hex string (e.g. "#8A4FFF" or "8A4FFF").
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hexString.count {
        case 3: // "RGB" (12‐bit, e.g. "F80")
            (a, r, g, b) = (255,
                            ((int >> 8) & 0xF) * 17,
                            ((int >> 4) & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // "RRGGBB" (24‐bit, e.g. "FF8800")
            (a, r, g, b) = (255,
                            (int >> 16) & 0xFF,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        case 8: // "AARRGGBB" (32‐bit)
            (a, r, g, b) = ((int >> 24) & 0xFF,
                            (int >> 16) & 0xFF,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    /// A convenience modifier to round only certain corners of a view.
    /// Example: .cornerRadius(12, corners: [.topLeft, .bottomLeft])
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
