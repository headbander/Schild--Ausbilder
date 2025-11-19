//
//  ContentView.swift
//  TXTtoCSVConverter
//
//  Haupt-View mit drei Schritten
//

import SwiftUI

struct ContentView: View {
    @StateObject private var manager = ConversionManager()

    var body: some View {
        ZStack {
            // Hintergrund
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()

            // Hauptinhalt
            Group {
                switch manager.currentStep {
                case .fileSelection:
                    FileDropView(manager: manager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))

                case .classFilter:
                    ClassFilterView(manager: manager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))

                case .conversion:
                    ExportView(manager: manager)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: manager.currentStep)

            // Loading Overlay
            if manager.isProcessing {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(.circular)

                        Text("Verarbeite...")
                            .font(.headline)
                    }
                    .padding(40)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 700, height: 550)
}
