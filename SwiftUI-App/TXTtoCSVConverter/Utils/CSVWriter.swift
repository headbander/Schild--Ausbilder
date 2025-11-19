//
//  CSVWriter.swift
//  TXTtoCSVConverter
//
//  Schreibt tab-getrennte CSV-Dateien
//

import Foundation

class CSVWriter {
    enum WriteError: Error {
        case encodingError
        case writeError

        var localizedDescription: String {
            switch self {
            case .encodingError:
                return "Encoding-Fehler beim Schreiben"
            case .writeError:
                return "Fehler beim Schreiben der Datei"
            }
        }
    }

    /// Schreibt StudentRecords in eine tab-getrennte CSV-Datei
    static func write(records: [StudentRecord], to url: URL) throws -> Int {
        var csvContent = ""

        // Header-Zeile
        csvContent += StudentRecord.outputHeaders.joined(separator: "\t")
        csvContent += "\n"

        // Datenzeilen
        for record in records {
            csvContent += record.toCSVRow()
            csvContent += "\n"
        }

        // Als UTF-8 schreiben
        guard let data = csvContent.data(using: .utf8) else {
            throw WriteError.encodingError
        }

        do {
            try data.write(to: url)
            return records.count
        } catch {
            throw WriteError.writeError
        }
    }
}
