//
//  ExportView_Tahoe.swift
//  TXTtoCSVConverter
//
//  SCHRITT 3: Export mit Liquid Glass Design (macOS Tahoe)
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportView_Tahoe: View {
    @ObservedObject var manager: ConversionManager
    @State private var showSuccess = false
    @State private var confettiTrigger = 0

    var body: some View {
        ZStack {
            // Mesh Gradient Background
            Color.meshBackground
                .ignoresSafeArea()

            if manager.successMessage != nil {
                successView
            } else {
                readyToExportView
            }
        }
    }

    // MARK: - Ready to Export View

    private var readyToExportView: some View {
        VStack(spacing: TahoeSpacing.xl) {
            Spacer()

            // Header
            VStack(spacing: TahoeSpacing.md) {
                LiquidGlassIconBadge(
                    systemName: "arrow.down.doc.fill",
                    gradient: .liquidGreenGradient,
                    size: 80
                )

                Text("Bereit zum Export")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primary, .primary.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Schritt 3 von 3: Exportieren")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }

            // Zusammenfassung
            LiquidGlassCard {
                VStack(spacing: TahoeSpacing.lg) {
                    // Dateiinfo
                    SummaryRow_Tahoe(
                        icon: "doc.text.fill",
                        iconGradient: .liquidBlueGradient,
                        title: "Quelldatei",
                        value: manager.selectedFileURL?.lastPathComponent ?? "—"
                    )

                    Divider()
                        .background(.secondary.opacity(0.2))

                    // Klassen-Info
                    SummaryRow_Tahoe(
                        icon: "checklist.checked",
                        iconGradient: .liquidPurpleGradient,
                        title: "Ausgewählte Klassen",
                        value: "\(manager.selectedClasses.count) von \(manager.availableClasses.count)"
                    )

                    Divider()
                        .background(.secondary.opacity(0.2))

                    // Einträge-Info
                    SummaryRow_Tahoe(
                        icon: "person.2.fill",
                        iconGradient: .liquidOrangeGradient,
                        title: "Einträge zum Export",
                        value: "\(manager.filteredRecords.count)"
                    )

                    // Klassen-Tags
                    if !manager.selectedClasses.isEmpty {
                        Divider()
                            .background(.secondary.opacity(0.2))

                        VStack(alignment: .leading, spacing: TahoeSpacing.sm) {
                            Text("Klassen:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)

                            FlowLayout(spacing: TahoeSpacing.xs) {
                                ForEach(Array(manager.selectedClasses).sorted(), id: \.self) { className in
                                    ClassTag(className: className)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxWidth: 600)
            .padding(.horizontal, TahoeSpacing.xxl)

            // Export-Button
            Button(action: openSavePanel) {
                Label("CSV exportieren", systemImage: "arrow.down.circle.fill")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .buttonStyle(LiquidGlassButtonStyle(gradient: .liquidGreenGradient, size: .large))
            .disabled(manager.isProcessing)
            .padding(.horizontal, TahoeSpacing.xxl)

            // Fehleranzeige
            if let error = manager.errorMessage {
                errorBanner(error)
            }

            Spacer()

            // Navigation
            HStack {
                Button(action: { manager.currentStep = .classFilter }) {
                    Label("Zurück", systemImage: "arrow.left")
                        .font(.title3)
                }
                .buttonStyle(SecondaryGlassButtonStyle())
                .controlSize(.large)

                Spacer()
            }
            .padding(.horizontal, TahoeSpacing.xxl)
            .padding(.bottom, TahoeSpacing.lg)
        }
    }

    // MARK: - Success View

    private var successView: some View {
        VStack(spacing: TahoeSpacing.xxl) {
            Spacer()

            // Success Animation
            VStack(spacing: TahoeSpacing.xl) {
                ZStack {
                    // Glow-Effekt
                    Circle()
                        .fill(Color.tahoeGreen.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .blur(radius: 40)
                        .scaleEffect(showSuccess ? 1.2 : 0.8)
                        .opacity(showSuccess ? 0.6 : 0.0)

                    // Haupt-Icon
                    LiquidGlassIconBadge(
                        systemName: "checkmark.circle.fill",
                        gradient: .liquidGreenGradient,
                        size: 120
                    )
                    .scaleEffect(showSuccess ? 1.0 : 0.5)
                    .opacity(showSuccess ? 1.0 : 0.0)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: showSuccess)

                VStack(spacing: TahoeSpacing.sm) {
                    Text("Erfolgreich!")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.tahoeGreen, .tahoeGreen.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(showSuccess ? 1.0 : 0.8)
                        .opacity(showSuccess ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: showSuccess)

                    if let message = manager.successMessage {
                        Text(message)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, TahoeSpacing.xxl)
                            .opacity(showSuccess ? 1.0 : 0.0)
                            .animation(.easeIn.delay(0.5), value: showSuccess)
                    }
                }
            }

            // Neue Konvertierung Button
            Button(action: manager.reset) {
                Label("Neue Konvertierung", systemImage: "arrow.counterclockwise")
                    .font(.title3)
            }
            .buttonStyle(LiquidGlassButtonStyle(gradient: .liquidBlueGradient, size: .large))
            .scaleEffect(showSuccess ? 1.0 : 0.8)
            .opacity(showSuccess ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.7), value: showSuccess)

            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showSuccess = true
                confettiTrigger += 1
            }
        }
    }

    // MARK: - Helper Views

    private func errorBanner(_ error: String) -> some View {
        HStack(spacing: TahoeSpacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(.red)

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
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, TahoeSpacing.xxl)
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

        if let sourceURL = manager.selectedFileURL {
            let baseName = sourceURL.deletingPathExtension().lastPathComponent
            panel.nameFieldStringValue = "\(baseName)_converted.csv"
        } else {
            panel.nameFieldStringValue = "converted.csv"
        }

        let response = panel.runModal()
        guard response == .OK else { return }
        guard let url = panel.url else { return }

        manager.exportToCSV(url: url)
    }
}

// MARK: - Summary Row

struct SummaryRow_Tahoe: View {
    let icon: String
    let iconGradient: LinearGradient
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: TahoeSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconGradient)
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer()
        }
    }
}

// MARK: - Class Tag

struct ClassTag: View {
    let className: String

    var body: some View {
        Text(className)
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .padding(.horizontal, TahoeSpacing.sm)
            .padding(.vertical, TahoeSpacing.xs)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.tahoeBlue.opacity(0.2), lineWidth: 1)
            )
    }
}

// MARK: - Flow Layout (wiederverwendet)

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
    return ExportView_Tahoe(manager: manager)
        .frame(width: 900, height: 700)
}
