//
//  CSVParser.swift
//  TXTtoCSVConverter
//
//  Parser für semikolon-getrennte CSV/TXT-Dateien
//  WICHTIG: Namen sind OPTIONAL, nur "Klasse" ist PFLICHT!
//

import Foundation

class CSVParser {
    enum ParseError: Error {
        case invalidFormat
        case fileReadError
        case encodingError
        case missingHeaders
        case noClassColumn

        var localizedDescription: String {
            switch self {
            case .invalidFormat:
                return "Ungültiges Dateiformat. Erwartet wird eine Semikolon-getrennte TXT-Datei."
            case .fileReadError:
                return "Datei konnte nicht gelesen werden."
            case .encodingError:
                return "Encoding-Fehler (erwartet UTF-8)."
            case .missingHeaders:
                return "Keine Header-Zeile gefunden."
            case .noClassColumn:
                return "Keine 'Klasse'-Spalte gefunden. Diese Spalte ist zwingend erforderlich!"
            }
        }
    }

    /// Liest eine semikolon-getrennte TXT-Datei und parst sie zu StudentRecords
    /// WICHTIG: Nur "Klasse" ist Pflicht, alle anderen Felder (Namen, GUID, Email) sind optional!
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

        // Finde Spalten-Indizes - NUR "Klasse" ist PFLICHT!
        guard let classIndex = headers.firstIndex(where: {
            $0.lowercased().contains("klasse")
        }) else {
            throw ParseError.noClassColumn
        }

        // Alle anderen Spalten sind OPTIONAL
        let guidIndex = headers.firstIndex(where: {
            $0.lowercased().contains("guid") || $0.lowercased().contains("eindeutige nummer")
        })
        let lastNameIndex = headers.firstIndex(where: {
            $0.lowercased() == "nachname" || $0.lowercased() == "name"
        })
        let firstNameIndex = headers.firstIndex(where: {
            $0.lowercased() == "vorname"
        })
        let emailIndex = headers.firstIndex(where: {
            $0.lowercased().contains("betreuer e-mail") || $0.lowercased().contains("email")
        })
        let supervisorIndex = headers.firstIndex(where: {
            $0.lowercased().contains("betreuer name")
        })

        // Parse Datenzeilen
        var records: [StudentRecord] = []

        for line in lines.dropFirst() {
            let fields = parseCSVLine(line, delimiter: ";")

            // Überspringe Zeilen, die zu kurz sind
            guard fields.count > classIndex else {
                continue
            }

            // WICHTIG: Klasse MUSS vorhanden und nicht leer sein!
            let className = fields[classIndex].trimmingCharacters(in: .whitespaces)
            guard !className.isEmpty else {
                continue // Überspringe Zeilen ohne Klasse
            }

            var record = StudentRecord()
            record.className = className

            // ALLE anderen Felder sind OPTIONAL - verwende leere Strings als Default
            if let guidIdx = guidIndex, guidIdx < fields.count {
                record.guid = fields[guidIdx].trimmingCharacters(in: .whitespaces)
            }

            if let lastNameIdx = lastNameIndex, lastNameIdx < fields.count {
                record.lastName = fields[lastNameIdx].trimmingCharacters(in: .whitespaces)
            }

            if let firstNameIdx = firstNameIndex, firstNameIdx < fields.count {
                record.firstName = fields[firstNameIdx].trimmingCharacters(in: .whitespaces)
            }

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
