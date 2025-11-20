//
//  LiquidGlassDesign.swift
//  TXTtoCSVConverter
//
//  macOS Tahoe 26.0 - Liquid Glass Design System
//  Inspired by visionOS and Apple's latest design language
//

import SwiftUI

// MARK: - Liquid Glass Material
struct LiquidGlassMaterial {
    static let ultraThin = Material.ultraThinMaterial
    static let thin = Material.thinMaterial
    static let regular = Material.regularMaterial
    static let thick = Material.thickMaterial
}

// MARK: - Colors (macOS Tahoe Palette)
extension Color {
    // Primärfarben - Tahoe Style
    static let tahoeBlue = Color(red: 0.0, green: 0.48, blue: 1.0)  // #007AFF
    static let tahoePurple = Color(red: 0.69, green: 0.32, blue: 0.87)  // #BF5AF2
    static let tahoeGreen = Color(red: 0.20, green: 0.78, blue: 0.35)  // #32C759
    static let tahoeOrange = Color(red: 1.0, green: 0.62, blue: 0.04)  // #FF9F0A
    static let tahoePink = Color(red: 1.0, green: 0.18, blue: 0.33)  // #FF2D55

    // Liquid Glass Gradienten (mehrschichtig)
    static var liquidBlueGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.40, green: 0.78, blue: 1.0),    // Light Blue
                Color(red: 0.10, green: 0.56, blue: 1.0),    // Medium Blue
                Color(red: 0.0, green: 0.48, blue: 1.0)      // Deep Blue
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var liquidPurpleGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.82, green: 0.52, blue: 1.0),
                Color(red: 0.69, green: 0.32, blue: 0.87),
                Color(red: 0.56, green: 0.22, blue: 0.72)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var liquidGreenGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.47, green: 0.95, blue: 0.69),
                Color(red: 0.20, green: 0.78, blue: 0.35),
                Color(red: 0.15, green: 0.68, blue: 0.28)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var liquidOrangeGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.76, blue: 0.35),
                Color(red: 1.0, green: 0.62, blue: 0.04),
                Color(red: 0.91, green: 0.52, blue: 0.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // Mesh Gradient Background (Tahoe Style)
    static var meshBackground: some View {
        MeshGradientBackground()
    }
}

// MARK: - Mesh Gradient Background (visionOS inspired)
struct MeshGradientBackground: View {
    var body: some View {
        ZStack {
            // Base Layer
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.96, blue: 0.98),
                    Color(red: 0.88, green: 0.91, blue: 0.96)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Accent Blobs (Liquid Glass Style)
            Circle()
                .fill(Color.tahoeBlue.opacity(0.08))
                .blur(radius: 80)
                .frame(width: 400, height: 400)
                .offset(x: -150, y: -200)

            Circle()
                .fill(Color.tahoePurple.opacity(0.06))
                .blur(radius: 100)
                .frame(width: 500, height: 500)
                .offset(x: 200, y: 100)

            Circle()
                .fill(Color.tahoeGreen.opacity(0.05))
                .blur(radius: 90)
                .frame(width: 350, height: 350)
                .offset(x: -100, y: 250)
        }
    }
}

// MARK: - Spacing (Tahoe System)
enum TahoeSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius (Squircle Style)
enum TahoeRadius {
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 28
    static let xxxl: CGFloat = 32

    // Kontinuierliche Kurven (iOS/macOS Tahoe)
    static func continuous(_ size: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: size, style: .continuous)
    }
}

// MARK: - Liquid Glass Modifiers
extension View {
    // Hauptglas-Effekt
    func liquidGlass(
        material: Material = .ultraThinMaterial,
        radius: CGFloat = TahoeRadius.xl,
        showBorder: Bool = true
    ) -> some View {
        self
            .background(material)
            .clipShape(TahoeRadius.continuous(radius))
            .overlay(
                TahoeRadius.continuous(radius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.3),
                                .white.opacity(0.1),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: showBorder ? 1 : 0
                    )
            )
            .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 8)
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }

    // Schwebender Glass-Effekt (floating)
    func floatingGlass(elevation: GlassElevation = .medium) -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(TahoeRadius.continuous(TahoeRadius.xl))
            .overlay(
                TahoeRadius.continuous(TahoeRadius.xl)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .white.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: .black.opacity(elevation.shadowOpacity), radius: elevation.shadowRadius, y: elevation.yOffset)
    }

    // Specular Highlight (Prism-Effekt)
    func specularHighlight() -> some View {
        self.overlay(
            LinearGradient(
                colors: [
                    .white.opacity(0.4),
                    .white.opacity(0.2),
                    .clear
                ],
                startPoint: .topLeading,
                endPoint: UnitPoint(x: 0.3, y: 0.3)
            )
            .clipShape(TahoeRadius.continuous(TahoeRadius.xl))
            .blendMode(.overlay)
        )
    }

    // Innerer Glow
    func innerGlow(color: Color = .white, intensity: Double = 0.2) -> some View {
        self.overlay(
            TahoeRadius.continuous(TahoeRadius.xl)
                .stroke(color.opacity(intensity), lineWidth: 1)
                .blur(radius: 4)
                .blendMode(.screen)
        )
    }
}

enum GlassElevation {
    case low, medium, high

    var shadowOpacity: Double {
        switch self {
        case .low: return 0.08
        case .medium: return 0.15
        case .high: return 0.25
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .low: return 8
        case .medium: return 20
        case .high: return 32
        }
    }

    var yOffset: CGFloat {
        switch self {
        case .low: return 2
        case .medium: return 6
        case .high: return 12
        }
    }
}

// MARK: - Button Styles (Liquid Glass)
struct LiquidGlassButtonStyle: ButtonStyle {
    var gradient: LinearGradient = .liquidBlueGradient
    var size: ButtonSize = .medium

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                ZStack {
                    // Basis-Gradient
                    TahoeRadius.continuous(size.cornerRadius)
                        .fill(gradient)

                    // Specular Highlight
                    TahoeRadius.continuous(size.cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .blendMode(.overlay)
                }
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
            .shadow(color: .black.opacity(0.2), radius: configuration.isPressed ? 8 : 16, y: configuration.isPressed ? 2 : 6)
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
            case .small: return TahoeRadius.sm
            case .medium: return TahoeRadius.md
            case .large: return TahoeRadius.lg
            }
        }
    }
}

// Sekundärer Button (Glass Style)
struct SecondaryGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(TahoeRadius.continuous(TahoeRadius.md))
            .overlay(
                TahoeRadius.continuous(TahoeRadius.md)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Icon Badge (Liquid Glass)
struct LiquidGlassIconBadge: View {
    let systemName: String
    var gradient: LinearGradient = .liquidBlueGradient
    var size: CGFloat = 72

    var body: some View {
        ZStack {
            // Glow Effekt
            Circle()
                .fill(gradient)
                .blur(radius: 20)
                .opacity(0.4)
                .frame(width: size * 1.2, height: size * 1.2)

            // Haupt-Icon
            Circle()
                .fill(gradient)
                .overlay(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .blendMode(.overlay)
                )
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.2), radius: 20, y: 8)

            // Symbol
            Image(systemName: systemName)
                .font(.system(size: size * 0.45, weight: .medium))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        }
    }
}

// MARK: - Card Style (Liquid Glass)
struct LiquidGlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(TahoeSpacing.lg)
            .background(.regularMaterial)
            .clipShape(TahoeRadius.continuous(TahoeRadius.xl))
            .overlay(
                TahoeRadius.continuous(TahoeRadius.xl)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
            .shadow(color: .black.opacity(0.05), radius: 1, y: 1)
    }
}

// MARK: - Flow Layout

/// Wiederverwendbares Flow Layout für Tag-Ansichten und flexibles Wrapping
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, row) in result.rows.enumerated() {
            let rowY = bounds.minY + result.rowYPositions[index]
            for (subviewIndex, _) in row {
                let subview = subviews[subviewIndex]
                let size = subview.sizeThatFits(.unspecified)
                let x = bounds.minX + result.xOffsets[index][subviewIndex - (row.first?.0 ?? 0)]
                subview.place(at: CGPoint(x: x, y: rowY), proposal: ProposedViewSize(size))
            }
        }
    }

    struct FlowResult {
        var rows: [[(Int, ProposedViewSize)]] = []
        var rowYPositions: [CGFloat] = []
        var xOffsets: [[CGFloat]] = []
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentRow: [(Int, ProposedViewSize)] = []
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var currentRowHeight: CGFloat = 0
            var currentRowXOffsets: [CGFloat] = []

            for (index, subview) in subviews.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                let proposal = ProposedViewSize(size)

                if currentX + size.width > maxWidth && !currentRow.isEmpty {
                    rows.append(currentRow)
                    rowYPositions.append(currentY)
                    xOffsets.append(currentRowXOffsets)
                    currentY += currentRowHeight + spacing
                    currentRow = []
                    currentX = 0
                    currentRowHeight = 0
                    currentRowXOffsets = []
                }

                currentRowXOffsets.append(currentX)
                currentRow.append((index, proposal))
                currentX += size.width + spacing
                currentRowHeight = max(currentRowHeight, size.height)
            }

            if !currentRow.isEmpty {
                rows.append(currentRow)
                rowYPositions.append(currentY)
                xOffsets.append(currentRowXOffsets)
                currentY += currentRowHeight
            }

            size = CGSize(width: maxWidth, height: currentY)
        }
    }
}
