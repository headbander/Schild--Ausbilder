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

    // MARK: - Computed Properties
    var canProceedToClassFilter: Bool {
        selectedFileURL != nil
    }

    var canProceedToConversion: Bool {
        !selectedClasses.isEmpty
    }

    var filteredRecords: [StudentRecord] {
        allRecords.filter { selectedClasses.contains($0.className) }
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

    func goToConversion() {
        guard canProceedToConversion else { return }
        currentStep = .conversion
    }

    func reset() {
        currentStep = .fileSelection
        selectedFileURL = nil
        allRecords = []
        availableClasses = []
        selectedClasses = []
        errorMessage = nil
        successMessage = nil
    }

    // MARK: - Export
    func exportToCSV(url: URL) {
        isProcessing = true
        errorMessage = nil
        successMessage = nil

        do {
            let recordCount = try CSVWriter.write(records: filteredRecords, to: url)
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
    case conversion
}
