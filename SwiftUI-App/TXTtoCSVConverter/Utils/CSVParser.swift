//
//  CSVParser.swift
//  TXTtoCSVConverter
//
//  Parser für semikolon-getrennte CSV/TXT-Dateien
//

import Foundation

class CSVParser {
    enum ParseError: Error {
        case invalidFormat
        case fileReadError
        case encodingError
        case missingHeaders

        var localizedDescription: String {
            switch self {
            case .invalidFormat:
                return "Ungültiges Dateiformat"
            case .fileReadError:
                return "Datei konnte nicht gelesen werden"
            case .encodingError:
                return "Encoding-Fehler (erwartet UTF-8)"
            case .missingHeaders:
                return "Keine Header-Zeile gefunden"
            }
        }
    }

    /// Liest eine semikolon-getrennte TXT-Datei und parst sie zu StudentRecords
    static func parse(fileURL: URL) throws -> [StudentRecord] {
        // Datei lesen mit UTF-8
        guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
            throw ParseError.encodingError
        }

        let lines = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        guard !lines.isEmpty else {
            throw ParseError.missingHeaders
        }

        // Erste Zeile ist Header
        let headerLine = lines[0]
        let headers = parseCSVLine(headerLine, delimiter: ";")

        // Finde Spalten-Indizes
        guard let guidIndex = headers.firstIndex(where: { $0.contains("eindeutige Nummer") || $0.contains("GUID") }),
              let lastNameIndex = headers.firstIndex(of: "Nachname"),
              let firstNameIndex = headers.firstIndex(of: "Vorname"),
              let classIndex = headers.firstIndex(of: "Klasse") else {
            throw ParseError.invalidFormat
        }

        let emailIndex = headers.firstIndex(where: { $0.contains("Betreuer E-Mail") })
        let supervisorIndex = headers.firstIndex(where: { $0.contains("Betreuer Name") })

        // Parse Datenzeilen
        var records: [StudentRecord] = []

        for line in lines.dropFirst() {
            let fields = parseCSVLine(line, delimiter: ";")

            guard fields.count > max(guidIndex, lastNameIndex, firstNameIndex, classIndex) else {
                continue // Überspringe ungültige Zeilen
            }

            var record = StudentRecord()
            record.guid = fields[guidIndex].trimmingCharacters(in: .whitespaces)
            record.lastName = fields[lastNameIndex].trimmingCharacters(in: .whitespaces)
            record.firstName = fields[firstNameIndex].trimmingCharacters(in: .whitespaces)
            record.className = fields[classIndex].trimmingCharacters(in: .whitespaces)

            if let emailIdx = emailIndex, emailIdx < fields.count {
                record.supervisorEmail = fields[emailIdx].trimmingCharacters(in: .whitespaces)
            }

            if let supervisorIdx = supervisorIndex, supervisorIdx < fields.count {
                record.supervisorName = fields[supervisorIdx].trimmingCharacters(in: .whitespaces)
            }

            records.append(record)
        }

        return records
    }

    /// Parst eine CSV-Zeile unter Berücksichtigung von Anführungszeichen
    private static func parseCSVLine(_ line: String, delimiter: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        var previousChar: Character?

        for char in line {
            if char == "\"" {
                if previousChar == "\"" && insideQuotes {
                    // Doppelte Anführungszeichen = escaped quote
                    currentField.append(char)
                    previousChar = nil
                    continue
                }
                insideQuotes.toggle()
            } else if String(char) == delimiter && !insideQuotes {
                fields.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
            previousChar = char
        }

        // Letztes Feld hinzufügen
        fields.append(currentField)

        // Entferne führende/abschließende Anführungszeichen
        return fields.map { field in
            var cleaned = field
            if cleaned.hasPrefix("\"") && cleaned.hasSuffix("\"") {
                cleaned = String(cleaned.dropFirst().dropLast())
            }
            return cleaned
        }
    }

    /// Extrahiert alle einzigartigen Klassennamen aus Records
    static func extractUniqueClasses(from records: [StudentRecord]) -> [String] {
        let classes = Set(records.map { $0.className })
        return classes.sorted()
    }
}
