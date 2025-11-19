//
//  FileDropView_Tahoe.swift
//  TXTtoCSVConverter
//
//  SCHRITT 1: Datei-Upload mit Liquid Glass Design (macOS Tahoe)
//

import SwiftUI
import UniformTypeIdentifiers

struct FileDropView_Tahoe: View {
    @ObservedObject var manager: ConversionManager
    @State private var isDragging = false
    @State private var pulseAnimation = false

    var body: some View {
        ZStack {
            // Mesh Gradient Background
            Color.meshBackground
                .ignoresSafeArea()

            VStack(spacing: TahoeSpacing.xl) {
                Spacer()

                // Header mit Icon
                VStack(spacing: TahoeSpacing.md) {
                    LiquidGlassIconBadge(
                        systemName: "doc.text.fill",
                        gradient: .liquidBlueGradient,
                        size: 80
                    )
                    .scaleEffect(manager.selectedFileURL != nil ? 1.1 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: manager.selectedFileURL != nil)

                    Text("TXT zu CSV Konverter")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .primary.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("Schritt 1 von 3: Datei auswählen")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }

                // Drop Zone (Liquid Glass)
                LiquidGlassCard {
                    VStack(spacing: TahoeSpacing.lg) {
                        if let fileURL = manager.selectedFileURL {
                            // Datei ausgewählt
                            selectedFileContent(fileURL)
                        } else {
                            // Keine Datei ausgewählt
                            emptyDropZoneContent
                        }
                    }
                    .frame(height: 280)
                    .frame(maxWidth: 600)
                }
                .scaleEffect(isDragging ? 1.02 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
                .onDrop(of: [.fileURL], isTargeted: $isDragging) { providers in
                    handleDrop(providers)
                }

                // Fehleranzeige
                if let error = manager.errorMessage {
                    errorBanner(error)
                }

                Spacer()

                // Weiter-Button
                HStack {
                    Spacer()

                    Button(action: manager.goToClassFilter) {
                        Label("Weiter", systemImage: "arrow.right")
                            .font(.title3)
                    }
                    .buttonStyle(LiquidGlassButtonStyle(gradient: .liquidBlueGradient, size: .large))
                    .disabled(!manager.canProceedToClassFilter || manager.isProcessing)
                    .opacity(manager.canProceedToClassFilter ? 1.0 : 0.5)
                }
                .padding(.horizontal, TahoeSpacing.xxl)
                .padding(.bottom, TahoeSpacing.xl)
            }
        }
    }

    // MARK: - Subviews

    private var emptyDropZoneContent: some View {
        VStack(spacing: TahoeSpacing.xl) {
            // Animated Icon
            ZStack {
                Circle()
                    .fill(Color.tahoeBlue.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .opacity(pulseAnimation ? 0.3 : 0.6)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)

                Image(systemName: "arrow.down.doc.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.linearGradient(
                        colors: [.tahoeBlue, .tahoePurple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            }
            .onAppear { pulseAnimation = true }

            VStack(spacing: TahoeSpacing.xs) {
                Text("Datei hier ablegen")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("oder")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button(action: selectFile) {
                Label("Datei auswählen", systemImage: "folder.fill")
            }
            .buttonStyle(SecondaryGlassButtonStyle())
            .controlSize(.large)
        }
    }

    private func selectedFileContent(_ url: URL) -> some View {
        VStack(spacing: TahoeSpacing.lg) {
            // Success Icon
            ZStack {
                Circle()
                    .fill(Color.tahoeGreen.opacity(0.15))
                    .frame(width: 80, height: 80)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.linearGradient(
                        colors: [.tahoeGreen, .tahoeGreen.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .symbolEffect(.bounce, value: manager.selectedFileURL)
            }

            VStack(spacing: TahoeSpacing.xs) {
                Text(url.lastPathComponent)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Text("\(manager.allRecords.count) Einträge geladen")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Button(action: selectFile) {
                Label("Andere Datei wählen", systemImage: "arrow.triangle.2.circlepath")
                    .font(.subheadline)
            }
            .buttonStyle(SecondaryGlassButtonStyle())
        }
    }

    private func errorBanner(_ error: String) -> some View {
        HStack(spacing: TahoeSpacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(.orange)

            Text(error)
                .font(.body)
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(TahoeSpacing.md)
        .background(.regularMaterial)
        .clipShape(TahoeRadius.continuous(TahoeRadius.md))
        .overlay(
            TahoeRadius.continuous(TahoeRadius.md)
                .stroke(Color.tahoeOrange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, TahoeSpacing.xxl)
    }

    // MARK: - File Selection
    private func selectFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.plainText, .text]
        panel.message = "Wählen Sie eine TXT-Datei zum Konvertieren"

        if panel.runModal() == .OK, let url = panel.url {
            manager.selectFile(url)
        }
    }

    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        _ = provider.loadObject(ofClass: URL.self) { url, _ in
            guard let url = url else { return }

            DispatchQueue.main.async {
                if url.pathExtension.lowercased() == "txt" {
                    manager.selectFile(url)
                } else {
                    manager.errorMessage = "Bitte wählen Sie eine .txt Datei"
                }
            }
        }

        return true
    }
}

#Preview {
    FileDropView_Tahoe(manager: ConversionManager())
        .frame(width: 900, height: 700)
}
