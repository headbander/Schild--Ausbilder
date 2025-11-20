//
//  TrainerAssignmentView_Tahoe.swift
//  TXTtoCSVConverter
//
//  Ausbilder-Zuordnung für BVB-Klassen mit Liquid Glass Design
//

import SwiftUI

struct TrainerAssignmentView_Tahoe: View {
    @ObservedObject var manager: ConversionManager
    @State private var searchText = ""
    @State private var showAddEmailDialog = false
    @State private var selectedTrainerEmail: String?
    @State private var newEmail = ""
    @State private var showAnimation = false

    var body: some View {
        ZStack {
            // Mesh Gradient Background
            Color.meshBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header
                header

                // MARK: - Content
                ScrollView {
                    VStack(spacing: TahoeSpacing.lg) {
                        // Statistiken
                        statistics

                        // Suchfeld
                        searchField

                        // Trainer-Liste
                        trainerList
                    }
                    .padding(TahoeSpacing.xl)
                }
                .frame(maxHeight: .infinity)

                // MARK: - Footer Buttons
                footer
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                showAnimation = true
            }
        }
        .sheet(isPresented: $showAddEmailDialog) {
            addEmailDialog
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: TahoeSpacing.md) {
            HStack(spacing: TahoeSpacing.md) {
                LiquidGlassIconBadge(
                    systemName: "person.2.badge.gearshape",
                    gradient: .liquidPurpleGradient,
                    size: 56
                )
                .scaleEffect(showAnimation ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: showAnimation)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Ausbilder-Zuordnung")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text("BVB-Klassen: \(manager.bvbClasses.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, TahoeSpacing.xl)
            .padding(.top, TahoeSpacing.lg)

            // Info-Banner
            infoBanner
                .padding(.horizontal, TahoeSpacing.xl)
        }
        .padding(.bottom, TahoeSpacing.md)
        .background(.ultraThinMaterial)
    }

    private var infoBanner: some View {
        HStack(spacing: TahoeSpacing.md) {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundStyle(.tahoeBlue)

            Text("Ordne Ausbildern weitere E-Mail-Adressen zu. Alle Datensätze werden automatisch dupliziert.")
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(TahoeSpacing.md)
        .background(.thinMaterial)
        .clipShape(TahoeRadius.continuous(TahoeRadius.md))
        .overlay(
            TahoeRadius.continuous(TahoeRadius.md)
                .stroke(Color.tahoeBlue.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Statistics

    private var statistics: some View {
        HStack(spacing: TahoeSpacing.md) {
            StatCard(
                title: "BVB-Klassen",
                value: "\(manager.bvbClasses.count)",
                icon: "studentdesk",
                gradient: .liquidBlueGradient
            )

            StatCard(
                title: "Ausbilder",
                value: "\(manager.uniqueTrainerEmails.count)",
                icon: "person.2.fill",
                gradient: .liquidPurpleGradient
            )

            StatCard(
                title: "Zuordnungen",
                value: "\(totalMappings)",
                icon: "link",
                gradient: .liquidGreenGradient
            )

            StatCard(
                title: "Datensätze",
                value: "\(estimatedRecordCount)",
                icon: "doc.on.doc.fill",
                gradient: .liquidOrangeGradient
            )
        }
        .opacity(showAnimation ? 1.0 : 0.0)
        .offset(y: showAnimation ? 0 : 20)
        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: showAnimation)
    }

    // MARK: - Search Field

    private var searchField: some View {
        HStack(spacing: TahoeSpacing.md) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.body)

            TextField("Ausbilder suchen...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.body)

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(TahoeSpacing.md)
        .background(.ultraThinMaterial)
        .clipShape(TahoeRadius.continuous(TahoeRadius.md))
        .overlay(
            TahoeRadius.continuous(TahoeRadius.md)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }

    // MARK: - Trainer List

    private var trainerList: some View {
        LiquidGlassCard {
            if filteredTrainers.isEmpty {
                emptyState
            } else {
                VStack(spacing: TahoeSpacing.sm) {
                    ForEach(Array(filteredTrainers.enumerated()), id: \.element) { index, email in
                        TrainerRow(
                            email: email,
                            additionalEmails: manager.getAdditionalEmails(for: email),
                            recordCount: manager.bvbRecords.filter { $0.supervisorEmail == email }.count,
                            onAddEmail: {
                                selectedTrainerEmail = email
                                newEmail = ""
                                showAddEmailDialog = true
                            },
                            onRemoveEmail: { emailToRemove in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    manager.removeEmailMapping(from: email, email: emailToRemove)
                                }
                            }
                        )
                        .opacity(showAnimation ? 1.0 : 0.0)
                        .offset(y: showAnimation ? 0 : 20)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.05), value: showAnimation)

                        if index < filteredTrainers.count - 1 {
                            Divider()
                                .padding(.vertical, TahoeSpacing.xs)
                        }
                    }
                }
                .padding(TahoeSpacing.md)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: TahoeSpacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary.opacity(0.5))

            Text(searchText.isEmpty ? "Keine Ausbilder gefunden" : "Keine Ergebnisse für '\(searchText)'")
                .font(.headline)
                .foregroundStyle(.secondary)

            if !searchText.isEmpty {
                Button("Filter zurücksetzen") {
                    searchText = ""
                }
                .buttonStyle(SecondaryGlassButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(TahoeSpacing.xxl)
    }

    // MARK: - Footer

    private var footer: some View {
        HStack(spacing: TahoeSpacing.md) {
            Button(action: {
                manager.currentStep = .classFilter
            }) {
                HStack(spacing: TahoeSpacing.sm) {
                    Image(systemName: "chevron.left")
                    Text("Zurück")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, TahoeSpacing.md)
            }
            .buttonStyle(SecondaryGlassButtonStyle())

            Button(action: {
                manager.skipTrainerAssignment()
            }) {
                Text("Überspringen")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, TahoeSpacing.md)
            }
            .buttonStyle(SecondaryGlassButtonStyle())

            Button(action: {
                manager.applyTrainerMappings()
                manager.currentStep = .conversion
            }) {
                HStack(spacing: TahoeSpacing.sm) {
                    Text("Weiter")
                    Image(systemName: "chevron.right")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, TahoeSpacing.md)
            }
            .buttonStyle(LiquidGlassButtonStyle())
        }
        .padding(TahoeSpacing.lg)
        .background(.ultraThinMaterial)
    }

    // MARK: - Add Email Dialog

    private var addEmailDialog: some View {
        VStack(spacing: TahoeSpacing.xl) {
            // Header
            VStack(spacing: TahoeSpacing.sm) {
                LiquidGlassIconBadge(
                    systemName: "envelope.badge.fill",
                    gradient: .liquidBlueGradient,
                    size: 60
                )

                Text("E-Mail-Adresse hinzufügen")
                    .font(.title2)
                    .fontWeight(.bold)

                if let email = selectedTrainerEmail {
                    Text("Für: \(email)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, TahoeSpacing.lg)

            // Email Input
            VStack(alignment: .leading, spacing: TahoeSpacing.sm) {
                Text("Neue E-Mail-Adresse")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                TextField("z.B. b.rajner@dobeq.de", text: $newEmail)
                    .textFieldStyle(.plain)
                    .padding(TahoeSpacing.md)
                    .background(.ultraThinMaterial)
                    .clipShape(TahoeRadius.continuous(TahoeRadius.md))
                    .overlay(
                        TahoeRadius.continuous(TahoeRadius.md)
                            .stroke(Color.tahoeBlue.opacity(0.3), lineWidth: 1)
                    )
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }

            // Oder: Aus Liste wählen
            if !manager.uniqueTrainerEmails.isEmpty {
                VStack(alignment: .leading, spacing: TahoeSpacing.sm) {
                    Text("Oder aus Liste wählen")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    ScrollView {
                        VStack(spacing: TahoeSpacing.xs) {
                            ForEach(manager.uniqueTrainerEmails.filter { $0 != selectedTrainerEmail }, id: \.self) { email in
                                Button(action: {
                                    newEmail = email
                                }) {
                                    HStack {
                                        Image(systemName: newEmail == email ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(newEmail == email ? .tahoeBlue : .secondary)

                                        Text(email)
                                            .font(.subheadline)
                                            .foregroundStyle(.primary)

                                        Spacer()
                                    }
                                    .padding(TahoeSpacing.sm)
                                    .background(newEmail == email ? Color.tahoeBlue.opacity(0.1) : Color.clear)
                                    .clipShape(TahoeRadius.continuous(TahoeRadius.sm))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .padding(TahoeSpacing.sm)
                    .background(.ultraThinMaterial)
                    .clipShape(TahoeRadius.continuous(TahoeRadius.md))
                }
            }

            Spacer()

            // Buttons
            HStack(spacing: TahoeSpacing.md) {
                Button("Abbrechen") {
                    showAddEmailDialog = false
                }
                .buttonStyle(SecondaryGlassButtonStyle())
                .frame(maxWidth: .infinity)

                Button("Hinzufügen") {
                    if let originalEmail = selectedTrainerEmail, !newEmail.isEmpty {
                        manager.addEmailMapping(from: originalEmail, to: newEmail)
                        showAddEmailDialog = false
                    }
                }
                .buttonStyle(LiquidGlassButtonStyle())
                .frame(maxWidth: .infinity)
                .disabled(newEmail.isEmpty)
                .opacity(newEmail.isEmpty ? 0.5 : 1.0)
            }
        }
        .padding(TahoeSpacing.xl)
        .frame(width: 500, height: 600)
        .background(.regularMaterial)
    }

    // MARK: - Computed Properties

    private var filteredTrainers: [String] {
        if searchText.isEmpty {
            return manager.uniqueTrainerEmails
        } else {
            return manager.uniqueTrainerEmails.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private var totalMappings: Int {
        manager.trainerMappings.values.reduce(0) { $0 + $1.count }
    }

    private var estimatedRecordCount: Int {
        let originalCount = manager.bvbRecords.count
        var duplicates = 0

        for (email, additionalEmails) in manager.trainerMappings {
            let recordsForEmail = manager.bvbRecords.filter { $0.supervisorEmail == email }.count
            duplicates += recordsForEmail * additionalEmails.count
        }

        return originalCount + duplicates
    }
}

// MARK: - Trainer Row

struct TrainerRow: View {
    let email: String
    let additionalEmails: [String]
    let recordCount: Int
    let onAddEmail: () -> Void
    let onRemoveEmail: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: TahoeSpacing.md) {
            // Header: Original Email
            HStack(spacing: TahoeSpacing.md) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(email)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)

                    Text("\(recordCount) Datensatz\(recordCount == 1 ? "" : "e")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button(action: onAddEmail) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("E-Mail hinzufügen")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.tahoeBlue)
                    .padding(.horizontal, TahoeSpacing.md)
                    .padding(.vertical, TahoeSpacing.sm)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.tahoeBlue.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }

            // Zusätzliche E-Mails
            if !additionalEmails.isEmpty {
                VStack(alignment: .leading, spacing: TahoeSpacing.sm) {
                    Text("Zusätzliche E-Mails:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    FlowLayout(spacing: TahoeSpacing.sm) {
                        ForEach(additionalEmails, id: \.self) { additionalEmail in
                            EmailTag(
                                email: additionalEmail,
                                onRemove: {
                                    onRemoveEmail(additionalEmail)
                                }
                            )
                        }
                    }
                }
                .padding(TahoeSpacing.sm)
                .background(Color.tahoeBlue.opacity(0.05))
                .clipShape(TahoeRadius.continuous(TahoeRadius.sm))
            }
        }
    }
}

// MARK: - Email Tag

struct EmailTag: View {
    let email: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text(email)
                .font(.caption)
                .foregroundStyle(.primary)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, TahoeSpacing.sm)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.tahoeBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let gradient: LinearGradient

    var body: some View {
        VStack(spacing: TahoeSpacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(gradient)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(TahoeSpacing.md)
        .background(.ultraThinMaterial)
        .clipShape(TahoeRadius.continuous(TahoeRadius.md))
        .overlay(
            TahoeRadius.continuous(TahoeRadius.md)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
}

#Preview {
    let manager = ConversionManager()
    manager.selectedClasses = ["BVB1", "BVB2", "10A"]
    manager.availableClasses = ["BVB1", "BVB2", "BVB3", "10A", "11B"]

    // Simuliere BVB-Datensätze
    var record1 = StudentRecord()
    record1.className = "BVB1"
    record1.supervisorEmail = "mader@bkh-handwerk.de"
    record1.lastName = "Beddoes"
    record1.firstName = "Justin"

    var record2 = StudentRecord()
    record2.className = "BVB1"
    record2.supervisorEmail = "mader@bkh-handwerk.de"
    record2.lastName = "Müller"
    record2.firstName = "Anna"

    var record3 = StudentRecord()
    record3.className = "BVB2"
    record3.supervisorEmail = "schmidt@example.de"
    record3.lastName = "Schmidt"
    record3.firstName = "Peter"

    manager.allRecords = [record1, record2, record3]

    return TrainerAssignmentView_Tahoe(manager: manager)
        .frame(width: 1000, height: 800)
}
