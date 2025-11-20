//
//  ConversionManager.swift
//  TXTtoCSVConverter
//
//  Verwaltet den gesamten Konvertierungsprozess
//

import Foundation
import SwiftUI
import Combine  // WICHTIG: Für @Published Properties!

@MainActor
class ConversionManager: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStep: ConversionStep = .fileSelection
    @Published var selectedFileURL: URL?
    @Published var allRecords: [StudentRecord] = []
    @Published var availableClasses: [String] = []
    @Published var selectedClasses: Set<String> = []
    @Published var isProcessing = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    // MARK: - Trainer Assignment (BVB-Klassen)
    @Published var trainerMappings: [String: [String]] = [:] // Original Email -> Zusätzliche Emails
    @Published var processedRecords: [StudentRecord] = [] // Nach Duplizierung

    // MARK: - Computed Properties
    var canProceedToClassFilter: Bool {
        selectedFileURL != nil
    }

    var canProceedToConversion: Bool {
        !selectedClasses.isEmpty
    }

    var canProceedToTrainerAssignment: Bool {
        !selectedClasses.isEmpty && hasBVBClasses
    }

    var hasBVBClasses: Bool {
        selectedClasses.contains(where: { $0.uppercased().hasPrefix("BVB") })
    }

    var bvbClasses: [String] {
        selectedClasses.filter { $0.uppercased().hasPrefix("BVB") }.sorted()
    }

    var filteredRecords: [StudentRecord] {
        allRecords.filter { selectedClasses.contains($0.className) }
    }

    var bvbRecords: [StudentRecord] {
        filteredRecords.filter { $0.className.uppercased().hasPrefix("BVB") }
    }

    var uniqueTrainerEmails: [String] {
        let emails = Set(bvbRecords.map { $0.supervisorEmail }.filter { !$0.isEmpty })
        return emails.sorted()
    }

    var finalRecords: [StudentRecord] {
        processedRecords.isEmpty ? filteredRecords : processedRecords
    }

    // MARK: - File Selection
    func selectFile(_ url: URL) {
        selectedFileURL = url
        loadFile()
    }

    func loadFile() {
        guard let url = selectedFileURL else { return }

        isProcessing = true
        errorMessage = nil

        do {
            allRecords = try CSVParser.parse(fileURL: url)
            availableClasses = CSVParser.extractUniqueClasses(from: allRecords)
            isProcessing = false

            if availableClasses.isEmpty {
                errorMessage = "Keine Klassen in der Datei gefunden"
            }
        } catch let error as CSVParser.ParseError {
            errorMessage = error.localizedDescription
            isProcessing = false
        } catch {
            errorMessage = "Unbekannter Fehler: \(error.localizedDescription)"
            isProcessing = false
        }
    }

    // MARK: - Class Selection
    func selectAllClasses() {
        selectedClasses = Set(availableClasses)
    }

    func deselectAllClasses() {
        selectedClasses.removeAll()
    }

    func toggleClass(_ className: String) {
        if selectedClasses.contains(className) {
            selectedClasses.remove(className)
        } else {
            selectedClasses.insert(className)
        }
    }

    // MARK: - Navigation
    func goToClassFilter() {
        guard canProceedToClassFilter else { return }
        currentStep = .classFilter
    }

    func goToTrainerAssignment() {
        guard canProceedToTrainerAssignment else { return }
        currentStep = .trainerAssignment
    }

    func goToConversion() {
        if hasBVBClasses {
            // Wenn BVB-Klassen vorhanden sind, gehe zu Trainer Assignment
            goToTrainerAssignment()
        } else {
            // Sonst direkt zu Conversion
            currentStep = .conversion
        }
    }

    func skipTrainerAssignment() {
        currentStep = .conversion
    }

    func reset() {
        currentStep = .fileSelection
        selectedFileURL = nil
        allRecords = []
        availableClasses = []
        selectedClasses = []
        trainerMappings = [:]
        processedRecords = []
        errorMessage = nil
        successMessage = nil
    }

    // MARK: - Trainer Assignment
    func addEmailMapping(from originalEmail: String, to additionalEmail: String) {
        if trainerMappings[originalEmail] == nil {
            trainerMappings[originalEmail] = []
        }
        if !trainerMappings[originalEmail]!.contains(additionalEmail) {
            trainerMappings[originalEmail]!.append(additionalEmail)
        }
    }

    func removeEmailMapping(from originalEmail: String, email: String) {
        trainerMappings[originalEmail]?.removeAll { $0 == email }
        if trainerMappings[originalEmail]?.isEmpty == true {
            trainerMappings.removeValue(forKey: originalEmail)
        }
    }

    func getAdditionalEmails(for email: String) -> [String] {
        trainerMappings[email] ?? []
    }

    func applyTrainerMappings() {
        isProcessing = true
        errorMessage = nil

        // Starte mit allen gefilterten Records
        var result: [StudentRecord] = filteredRecords

        // Für jedes Mapping, dupliziere die betroffenen Datensätze
        for (originalEmail, additionalEmails) in trainerMappings {
            let recordsToProcess = result.filter { $0.supervisorEmail == originalEmail }

            for additionalEmail in additionalEmails {
                for record in recordsToProcess {
                    var duplicate = record
                    duplicate.supervisorEmail = additionalEmail
                    result.append(duplicate)
                }
            }
        }

        processedRecords = result
        isProcessing = false
    }

    // MARK: - Export
    func exportToCSV(url: URL) {
        isProcessing = true
        errorMessage = nil
        successMessage = nil

        do {
            let recordCount = try CSVWriter.write(records: finalRecords, to: url)
            successMessage = "✓ Erfolgreich exportiert!\n\n\(recordCount) Zeile(n) wurden konvertiert."
            isProcessing = false
        } catch let error as CSVWriter.WriteError {
            errorMessage = error.localizedDescription
            isProcessing = false
        } catch {
            errorMessage = "Fehler beim Exportieren: \(error.localizedDescription)"
            isProcessing = false
        }
    }
}

// MARK: - Conversion Steps
enum ConversionStep {
    case fileSelection
    case classFilter
    case trainerAssignment  // NEU: Ausbilder-Zuordnung für BVB-Klassen
    case conversion
}
