//
//  ExportView.swift
//  TXTtoCSVConverter
//
//  SCHRITT 3: Konvertierung & Export View
//

import SwiftUI

struct ExportView: View {
    @ObservedObject var manager: ConversionManager
    @State private var showingSavePanel = false

    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: manager.successMessage != nil ? "checkmark.circle.fill" : "arrow.down.doc")
                    .font(.system(size: 60))
                    .foregroundStyle(manager.successMessage != nil ? .green : .blue)
                    .symbolEffect(.bounce, value: manager.successMessage != nil)

                Text(manager.successMessage != nil ? "Erfolgreich!" : "Bereit zum Export")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Schritt 3: Export")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 40)

            // Zusammenfassung
            VStack(spacing: 20) {
                if manager.successMessage == nil {
                    // Vor dem Export
                    VStack(spacing: 16) {
                        SummaryRow(
                            icon: "doc.text",
                            title: "Quelldatei",
                            value: manager.selectedFileURL?.lastPathComponent ?? "—"
                        )

                        SummaryRow(
                            icon: "checklist",
                            title: "Ausgewählte Klassen",
                            value: "\(manager.selectedClasses.count) von \(manager.availableClasses.count)"
                        )

                        SummaryRow(
                            icon: "person.2",
                            title: "Einträge zum Export",
                            value: "\(manager.filteredRecords.count)"
                        )

                        Divider()
                            .padding(.vertical, 8)

                        // Klassen-Liste
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Klassen:")
                                .font(.headline)
                                .foregroundStyle(.secondary)

                            FlowLayout(spacing: 8) {
                                ForEach(Array(manager.selectedClasses).sorted(), id: \.self) { className in
                                    Text(className)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.accentColor.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(30)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(20)
                    .padding(.horizontal, 40)

                    // Export-Button
                    Button(action: openSavePanel) {
                        Label("CSV exportieren", systemImage: "square.and.arrow.down")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(manager.isProcessing)

                } else {
                    // Nach erfolgreichem Export
                    VStack(spacing: 20) {
                        Text(manager.successMessage ?? "")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(15)

                        Button(action: manager.reset) {
                            Label("Neue Konvertierung", systemImage: "arrow.counterclockwise")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .padding(.horizontal, 40)
                }

                // Fehleranzeige
                if let error = manager.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                        Text(error)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
            }

            Spacer()

            // Navigation Buttons (nur wenn noch nicht exportiert)
            if manager.successMessage == nil {
                HStack {
                    Button(action: { manager.currentStep = .classFilter }) {
                        Label("Zurück", systemImage: "arrow.left")
                            .font(.headline)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Save Panel
    private func openSavePanel() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.commaSeparatedText]
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.allowsOtherFileTypes = false
        panel.title = "CSV-Datei speichern"
        panel.message = "Wählen Sie einen Speicherort für die konvertierte CSV-Datei"

        // Vorschlag für Dateinamen
        if let sourceURL = manager.selectedFileURL {
            let baseName = sourceURL.deletingPathExtension().lastPathComponent
            panel.nameFieldStringValue = "\(baseName)_converted.csv"
        } else {
            panel.nameFieldStringValue = "converted.csv"
        }

        // Führe den Dialog modal aus (funktioniert mit korrekten Entitlements!)
        let response = panel.runModal()
        guard response == .OK else { return }
        guard let url = panel.url else { return }

        manager.exportToCSV(url: url)
    }
}

// MARK: - Subviews

struct SummaryRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }

            Spacer()
        }
    }
}

// Simple Flow Layout für Tags
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

#Preview {
    let manager = ConversionManager()
    manager.selectedClasses = ["10A", "10B", "9A"]
    manager.availableClasses = ["10A", "10B", "9A", "11C"]
    return ExportView(manager: manager)
        .frame(width: 600, height: 500)
}
