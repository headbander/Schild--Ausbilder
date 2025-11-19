//
//  ClassFilterView.swift
//  TXTtoCSVConverter
//
//  SCHRITT 2: Klassen-Filter View mit Checkboxen
//

import SwiftUI

struct ClassFilterView: View {
    @ObservedObject var manager: ConversionManager

    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "checklist")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .symbolEffect(.bounce, value: !manager.selectedClasses.isEmpty)

                Text("Klassen auswählen")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Schritt 2: Filter")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 40)

            // Klassen-Filter
            VStack(spacing: 20) {
                // Statistik
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

                // Auswahl-Buttons
                HStack(spacing: 12) {
                    Button(action: manager.selectAllClasses) {
                        Label("Alle auswählen", systemImage: "checkmark.circle.fill")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)

                    Button(action: manager.deselectAllClasses) {
                        Label("Keine auswählen", systemImage: "circle")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                }

                // Klassen-Liste mit Checkboxen
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(manager.availableClasses, id: \.self) { className in
                            ClassCheckboxRow(
                                className: className,
                                isSelected: manager.selectedClasses.contains(className),
                                count: manager.allRecords.filter { $0.className == className }.count
                            ) {
                                manager.toggleClass(className)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .frame(maxHeight: 300)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(15)
                .padding(.horizontal, 40)
            }

            Spacer()

            // Navigation Buttons
            HStack {
                Button(action: { manager.currentStep = .fileSelection }) {
                    Label("Zurück", systemImage: "arrow.left")
                        .font(.headline)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Spacer()

                Button(action: manager.goToConversion) {
                    Label("Konvertieren", systemImage: "arrow.right")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!manager.canProceedToConversion)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Subviews

struct ClassCheckboxRow: View {
    let className: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .blue : .secondary)

                Text(className)
                    .font(.body)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.accentColor : Color.gray.opacity(0.2), lineWidth: 1.5)
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
    manager.availableClasses = ["10A", "10B", "9A", "11C", "12D"]
    manager.selectedClasses = ["10A", "9A"]
    return ClassFilterView(manager: manager)
        .frame(width: 600, height: 500)
}
