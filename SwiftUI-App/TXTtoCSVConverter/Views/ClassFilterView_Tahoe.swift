//
//  ClassFilterView_Tahoe.swift
//  TXTtoCSVConverter
//
//  SCHRITT 2: Klassen-Filter mit Liquid Glass Design (macOS Tahoe)
//

import SwiftUI

struct ClassFilterView_Tahoe: View {
    @ObservedObject var manager: ConversionManager
    @State private var animateStats = false

    var body: some View {
        ZStack {
            // Mesh Gradient Background
            Color.meshBackground
                .ignoresSafeArea()

            VStack(spacing: TahoeSpacing.lg) {
                // Header
                header

                // Statistik Cards
                statisticsRow
                    .padding(.horizontal, TahoeSpacing.xxl)

                // Auswahl-Buttons
                selectionButtons
                    .padding(.horizontal, TahoeSpacing.xxl)

                // Klassen-Liste (dynamisch wachsend)
                classList
                    .padding(.horizontal, TahoeSpacing.xxl)

                // Navigation
                navigationBar
                    .padding(.horizontal, TahoeSpacing.xxl)
                    .padding(.bottom, TahoeSpacing.lg)
            }
        }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(spacing: TahoeSpacing.md) {
            LiquidGlassIconBadge(
                systemName: "checklist.checked",
                gradient: .liquidPurpleGradient,
                size: 72
            )
            .scaleEffect(animateStats ? 1.0 : 0.9)
            .opacity(animateStats ? 1.0 : 0.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animateStats)

            Text("Klassen auswählen")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Schritt 2 von 3: Filter")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(.top, TahoeSpacing.lg)
        .onAppear { animateStats = true }
    }

    private var statisticsRow: some View {
        HStack(spacing: TahoeSpacing.md) {
            StatisticCard(
                title: "Gefunden",
                value: "\(manager.availableClasses.count)",
                icon: "list.bullet.rectangle",
                gradient: .liquidBlueGradient,
                delay: 0.0
            )

            StatisticCard(
                title: "Ausgewählt",
                value: "\(manager.selectedClasses.count)",
                icon: "checkmark.circle.fill",
                gradient: .liquidGreenGradient,
                delay: 0.1
            )

            StatisticCard(
                title: "Einträge",
                value: "\(manager.filteredRecords.count)",
                icon: "person.2.fill",
                gradient: .liquidOrangeGradient,
                delay: 0.2
            )
        }
    }

    private var selectionButtons: some View {
        HStack(spacing: TahoeSpacing.md) {
            Button(action: manager.selectAllClasses) {
                Label("Alle auswählen", systemImage: "checkmark.circle.fill")
                    .font(.body)
                    .fontWeight(.medium)
            }
            .buttonStyle(SecondaryGlassButtonStyle())
            .controlSize(.large)

            Button(action: manager.deselectAllClasses) {
                Label("Alle abwählen", systemImage: "circle")
                    .font(.body)
                    .fontWeight(.medium)
            }
            .buttonStyle(SecondaryGlassButtonStyle())
            .controlSize(.large)
        }
    }

    private var classList: some View {
        LiquidGlassCard {
            ScrollView {
                LazyVStack(spacing: TahoeSpacing.sm) {
                    ForEach(Array(manager.availableClasses.sorted().enumerated()), id: \.element) { index, className in
                        ClassRow_Tahoe(
                            className: className,
                            isSelected: manager.selectedClasses.contains(className),
                            studentCount: manager.allRecords.filter { $0.className == className }.count,
                            onToggle: { manager.toggleClass(className) }
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.9).combined(with: .opacity),
                            removal: .scale(scale: 0.9).combined(with: .opacity)
                        ))
                        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.03), value: manager.availableClasses.count)
                    }
                }
                .padding(TahoeSpacing.md)
            }
            .frame(maxHeight: .infinity)
        }
    }

    private var navigationBar: some View {
        HStack(spacing: TahoeSpacing.md) {
            Button(action: { manager.currentStep = .fileSelection }) {
                Label("Zurück", systemImage: "arrow.left")
                    .font(.title3)
            }
            .buttonStyle(SecondaryGlassButtonStyle())
            .controlSize(.large)

            Spacer()

            Button(action: manager.goToConversion) {
                Label("Weiter zum Export", systemImage: "arrow.right")
                    .font(.title3)
            }
            .buttonStyle(LiquidGlassButtonStyle(gradient: .liquidPurpleGradient, size: .large))
            .disabled(!manager.canProceedToConversion)
            .opacity(manager.canProceedToConversion ? 1.0 : 0.5)
        }
    }
}

// MARK: - Class Row Component

struct ClassRow_Tahoe: View {
    let className: String
    let isSelected: Bool
    let studentCount: Int
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: TahoeSpacing.md) {
                // Checkbox
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.liquidBlueGradient : Color.clear)
                        .frame(width: 32, height: 32)

                    Circle()
                        .strokeBorder(
                            isSelected ? Color.clear : Color.secondary.opacity(0.3),
                            lineWidth: 2
                        )
                        .frame(width: 32, height: 32)

                    Image(systemName: isSelected ? "checkmark" : "")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)

                // Klassenname
                Text(className)
                    .font(.title3)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundStyle(.primary)

                Spacer()

                // Schüleranzahl Badge
                HStack(spacing: TahoeSpacing.xs) {
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(studentCount)")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, TahoeSpacing.sm)
                .padding(.vertical, TahoeSpacing.xs)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
            .padding(TahoeSpacing.md)
            .background(
                Group {
                    if isSelected {
                        TahoeRadius.continuous(TahoeRadius.md)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                TahoeRadius.continuous(TahoeRadius.md)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.tahoeBlue.opacity(0.5), .tahoePurple.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                    } else {
                        TahoeRadius.continuous(TahoeRadius.md)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                TahoeRadius.continuous(TahoeRadius.md)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                }
            )
            .shadow(color: .black.opacity(isSelected ? 0.12 : 0.05), radius: isSelected ? 12 : 4, y: isSelected ? 4 : 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Statistic Card

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let gradient: LinearGradient
    var delay: Double = 0.0

    @State private var appear = false

    var body: some View {
        VStack(spacing: TahoeSpacing.sm) {
            // Icon mit Gradient
            ZStack {
                Circle()
                    .fill(gradient)
                    .frame(width: 48, height: 48)
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, TahoeSpacing.lg)
        .background(.regularMaterial)
        .clipShape(TahoeRadius.continuous(TahoeRadius.xl))
        .overlay(
            TahoeRadius.continuous(TahoeRadius.xl)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .white.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 16, y: 6)
        .scaleEffect(appear ? 1.0 : 0.8)
        .opacity(appear ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay), value: appear)
        .onAppear { appear = true }
    }
}

#Preview {
    let manager = ConversionManager()
    manager.availableClasses = ["10A", "10B", "9A", "11C", "12D", "8B", "7A"]
    manager.selectedClasses = ["10A", "9A", "11C"]
    return ClassFilterView_Tahoe(manager: manager)
        .frame(width: 900, height: 700)
}
