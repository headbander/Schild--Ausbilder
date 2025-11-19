//
//  FileDropView.swift
//  TXTtoCSVConverter
//
//  SCHRITT 1: Datei-Upload View mit Drop-Zone
//

import SwiftUI
import UniformTypeIdentifiers

struct FileDropView: View {
    @ObservedObject var manager: ConversionManager
    @State private var isDragging = false

    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "doc.text")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .symbolEffect(.bounce, value: manager.selectedFileURL != nil)

                Text("TXT zu CSV Konverter")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Schritt 1: Datei auswählen")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 40)

            // Drop Zone
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            isDragging ? Color.accentColor : Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: 3, dash: [10, 5])
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isDragging ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.05))
                        )
                        .frame(height: 200)

                    if let fileURL = manager.selectedFileURL {
                        // Datei ausgewählt
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.green)

                            VStack(spacing: 4) {
                                Text(fileURL.lastPathComponent)
                                    .font(.headline)
                                Text("\(manager.allRecords.count) Einträge geladen")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Button(action: selectFile) {
                                Label("Andere Datei wählen", systemImage: "arrow.triangle.2.circlepath")
                                    .font(.subheadline)
                            }
                            .buttonStyle(.borderless)
                        }
                    } else {
                        // Keine Datei ausgewählt
                        VStack(spacing: 16) {
                            Image(systemName: "arrow.down.doc")
                                .font(.system(size: 50))
                                .foregroundStyle(.secondary)

                            Text("Datei hier ablegen")
                                .font(.title2)
                                .fontWeight(.medium)

                            Text("oder")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Button(action: selectFile) {
                                Label("Datei auswählen", systemImage: "folder")
                                    .font(.headline)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                    }
                }
                .onDrop(of: [.fileURL], isTargeted: $isDragging) { providers in
                    handleDrop(providers)
                }
                .padding(.horizontal, 40)

                // Fehleranzeige
                if let error = manager.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text(error)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(10)
                }
            }

            Spacer()

            // Weiter-Button
            HStack {
                Spacer()
                Button(action: manager.goToClassFilter) {
                    Label("Weiter", systemImage: "arrow.right")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!manager.canProceedToClassFilter || manager.isProcessing)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    FileDropView(manager: ConversionManager())
        .frame(width: 600, height: 500)
}
