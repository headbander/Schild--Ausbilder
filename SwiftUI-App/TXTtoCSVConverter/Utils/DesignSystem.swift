//
//  DesignSystem.swift
//  TXTtoCSVConverter
//
//  Modernes Apple Design System - Farben, Spacing, Effekte
//

import SwiftUI

// MARK: - Farben (Modern Apple Palette)
extension Color {
    // Primärfarben
    static let accentBlue = Color(red: 0.0, green: 0.48, blue: 1.0)  // #007AFF
    static let accentPurple = Color(red: 0.69, green: 0.32, blue: 0.87)  // #BF5AF2

    // Hintergründe (Dynamic)
    static let cardBackground = Color(nsColor: .controlBackgroundColor)
    static let secondaryBackground = Color(nsColor: .windowBackgroundColor)

    // Glassmorphism
    static let glassOverlay = Color.white.opacity(0.1)

    // Subtle Gradients
    static var blueGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.35, green: 0.78, blue: 0.98),  // Light Blue
                Color(red: 0.0, green: 0.48, blue: 1.0)     // System Blue
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var purpleGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.75, green: 0.52, blue: 0.98),
                Color(red: 0.56, green: 0.27, blue: 0.68)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var greenGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.31, green: 0.89, blue: 0.76),
                Color(red: 0.18, green: 0.8, blue: 0.44)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Spacing
enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
enum CornerRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 28
}

// MARK: - Shadow Modifiers
extension View {
    func modernShadow(intensity: ShadowIntensity = .medium) -> some View {
        self.shadow(
            color: Color.black.opacity(intensity.opacity),
            radius: intensity.radius,
            x: 0,
            y: intensity.yOffset
        )
    }

    func cardStyle() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(CornerRadius.xl)
            .modernShadow(intensity: .light)
    }

    func glassCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.xl)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.xl)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .modernShadow(intensity: .medium)
    }
}

enum ShadowIntensity {
    case light, medium, heavy

    var opacity: Double {
        switch self {
        case .light: return 0.08
        case .medium: return 0.15
        case .heavy: return 0.25
        }
    }

    var radius: CGFloat {
        switch self {
        case .light: return 8
        case .medium: return 16
        case .heavy: return 24
        }
    }

    var yOffset: CGFloat {
        switch self {
        case .light: return 2
        case .medium: return 4
        case .heavy: return 8
        }
    }
}

// MARK: - Button Styles
struct ModernButtonStyle: ButtonStyle {
    var color: Color = .accentBlue
    var size: ButtonSize = .medium

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .fill(color.gradient)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .modernShadow(intensity: .medium)
    }

    enum ButtonSize {
        case small, medium, large

        var font: Font {
            switch self {
            case .small: return .subheadline
            case .medium: return .body
            case .large: return .title3
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 24
            case .large: return 32
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }
    }
}

// MARK: - Icon Badge
struct IconBadge: View {
    let systemName: String
    var gradient: LinearGradient = .blueGradient
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            Circle()
                .fill(gradient)
                .frame(width: size, height: size)
                .modernShadow(intensity: .medium)

            Image(systemName: systemName)
                .font(.system(size: size * 0.45, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}
