//
//  StudentRecord.swift
//  TXTtoCSVConverter
//
//  Datenmodell für Student-Einträge
//

import Foundation

struct StudentRecord: Identifiable, Hashable {
    let id = UUID()

    // Eingabefelder aus TXT
    var guid: String = ""
    var lastName: String = ""
    var firstName: String = ""
    var className: String = ""
    var supervisorName: String = ""
    var supervisorEmail: String = ""

    // Ausgabefelder für CSV (die meisten bleiben leer)
    var csvID: String = ""
    var degree: String = ""
    var postgrade: String = ""
    var phone: String = ""
    var mobile: String = ""
    var displayRegisteredUserNames: String = ""
    var externalKey: String = ""
    var studentLastName: String = ""
    var studentFirstName: String = ""
    var studentShortName: String = ""
    var studentInternalId: String = ""

    // CSV Header für Eingabe
    static let inputHeaders = [
        "eindeutige Nummer (GUID)",
        "Nachname",
        "Vorname",
        "Klasse",
        "Allg. Adresse: Betreuer Name",
        "Allg. Adresse: Betreuer E-Mail"
    ]

    // CSV Header für Ausgabe
    static let outputHeaders = [
        "id",
        "lastName",
        "firstName",
        "degree",
        "grade",
        "postgrade",
        "email",
        "phone",
        "mobile",
        "displayRegisteredUserNames",
        "externalKey",
        "studentLastName",
        "studentFirstName",
        "studentShortName",
        "studentInternalId",
        "studentExternalId"
    ]

    // Konvertiert zu CSV-Zeile (Tab-getrennt)
    func toCSVRow() -> String {
        let fields = [
            csvID,                              // id
            lastName,                           // lastName
            firstName,                          // firstName
            degree,                             // degree
            className,                          // grade
            postgrade,                          // postgrade
            supervisorEmail,                    // email
            phone,                              // phone
            mobile,                             // mobile
            displayRegisteredUserNames,         // displayRegisteredUserNames
            externalKey,                        // externalKey
            studentLastName,                    // studentLastName
            studentFirstName,                   // studentFirstName
            studentShortName,                   // studentShortName
            studentInternalId,                  // studentInternalId
            guid                                // studentExternalId
        ]

        return fields.joined(separator: "\t")
    }
}
