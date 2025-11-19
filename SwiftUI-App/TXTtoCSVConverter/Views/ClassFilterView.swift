//
//  ClassFilterView.swift
//  TXTtoCSVConverter
//
//  SCHRITT 2: Klassen-Filter View mit Checkboxen - DYNAMISCHES LAYOUT
//

import SwiftUI

struct ClassFilterView: View {
    @ObservedObject var manager: ConversionManager

    var body: some View {
        VStack(spacing: 20) {
            // Header - FIXE HÖHE
            VStack(spacing: 8) {
                Image(systemName: "checklist")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                    .symbolEffect(.bounce, value: !manager.selectedClasses.isEmpty)

                Text("Klassen auswählen")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Wählen Sie die Klassen aus, die exportiert werden sollen")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)

            // Statistik - FIXE HÖHE
            HStack(spacing: 20) {
                StatCard(
                    title: "Gefunden",
                    value: "\(manager.availableClasses.count)",
                    icon: "list.bullet",
                    color: .blue
                )

                StatCard(
                    title: "Ausgewählt",
                    value: "\(manager.selectedClasses.count)",
                    icon: "checkmark.circle",
                    color: .green
                )

                StatCard(
                    title: "Einträge",
                    value: "\(manager.filteredRecords.count)",
                    icon: "person.2",
                    color: .orange
                )
            }
            .padding(.horizontal, 40)

            // Auswahl-Buttons - FIXE HÖHE
            HStack(spacing: 16) {
                Button(action: manager.selectAllClasses) {
                    Label("Alle auswählen", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Button(action: manager.deselectAllClasses) {
                    Label("Alle abwählen", systemImage: "circle")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }

            // Klassen-Liste - DYNAMISCH WACHSEND!
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(manager.availableClasses.sorted(), id: \.self) { className in
                        ClassSelectionRow(
                            className: className,
                            isSelected: manager.selectedClasses.contains(className),
                            studentCount: manager.allRecords.filter { $0.className == className }.count,
                            onToggle: { manager.toggleClass(className) }
                        )
                    }
                }
                .padding(20)
            }
            .frame(maxHeight: .infinity)  // WICHTIG: Nimmt allen verfügbaren Platz!
            .background(Color.gray.opacity(0.05))
            .cornerRadius(15)
            .padding(.horizontal, 40)

            // Navigation - FIXE HÖHE
            HStack {
                Button(action: { manager.currentStep = .fileSelection }) {
                    Label("Zurück", systemImage: "arrow.left")
                        .font(.headline)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Spacer()

                Button(action: manager.goToConversion) {
                    Label("Weiter zum Export", systemImage: "arrow.right")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!manager.canProceedToConversion)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Subviews

// Separate Row-Komponente für bessere Lesbarkeit und Performance
struct ClassSelectionRow: View {
    let className: String
    let isSelected: Bool
    let studentCount: Int
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Checkbox Icon
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 28))
                    .foregroundStyle(isSelected ? .blue : .gray)
                    .frame(width: 30)

                // Klassenname
                Text(className)
                    .font(.title3)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(.primary)

                Spacer()

                // Schüleranzahl
                Text("\(studentCount) Schüler")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(8)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.accentColor : Color.gray.opacity(0.2), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    let manager = ConversionManager()
    manager.availableClasses = ["10A", "10B", "9A", "11C", "12D", "8B", "7A", "13E"]
    manager.selectedClasses = ["10A", "9A"]
    return ClassFilterView(manager: manager)
        .frame(width: 900, height: 700)
}
