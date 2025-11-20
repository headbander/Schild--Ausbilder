//
//  ContentView.swift
//  TXTtoCSVConverter
//
//  Haupt-View mit Liquid Glass Design und flüssigen Animationen (macOS Tahoe)
//

import SwiftUI

struct ContentView: View {
    @StateObject private var manager = ConversionManager()

    var body: some View {
        ZStack {
            // Konstanter Mesh Gradient Background
            Color.meshBackground
                .ignoresSafeArea()

            // Hauptinhalt mit flüssigen Übergängen
            Group {
                switch manager.currentStep {
                case .fileSelection:
                    FileDropView_Tahoe(manager: manager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                            removal: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 1.05))
                        ))
                        .zIndex(1)

                case .classFilter:
                    ClassFilterView_Tahoe(manager: manager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                            removal: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 1.05))
                        ))
                        .zIndex(2)

                case .trainerAssignment:
                    TrainerAssignmentView_Tahoe(manager: manager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                            removal: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 1.05))
                        ))
                        .zIndex(3)

                case .conversion:
                    ExportView_Tahoe(manager: manager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                            removal: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 1.05))
                        ))
                        .zIndex(4)
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.75), value: manager.currentStep)

            // Loading Overlay (Liquid Glass)
            if manager.isProcessing {
                loadingOverlay
            }
        }
        .preferredColorScheme(nil)  // Unterstützt Light & Dark Mode
    }

    // MARK: - Loading Overlay

    private var loadingOverlay: some View {
        ZStack {
            // Backdrop
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()

            // Loading Card
            VStack(spacing: TahoeSpacing.lg) {
                // Animated Progress
                ZStack {
                    Circle()
                        .stroke(Color.primary.opacity(0.1), lineWidth: 4)
                        .frame(width: 60, height: 60)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [.tahoeBlue, .tahoePurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(manager.isProcessing ? 360 : 0))
                        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: manager.isProcessing)
                }

                Text("Verarbeite...")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            .padding(TahoeSpacing.xxl)
            .background(.ultraThinMaterial)
            .clipShape(TahoeRadius.continuous(TahoeRadius.xxl))
            .overlay(
                TahoeRadius.continuous(TahoeRadius.xxl)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 30, y: 15)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: manager.isProcessing)
    }
}

#Preview {
    ContentView()
        .frame(width: 1000, height: 800)
}
