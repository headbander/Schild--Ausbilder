# TXT zu CSV Konverter - Native macOS SwiftUI App

Eine moderne, native macOS-Anwendung zum Konvertieren von semikolon-getrennten TXT-Dateien in tab-getrennte CSV-Dateien mit Klassenfilter.

## Features

- **Drei-Schritt-Workflow**:
  1. Datei-Upload mit Drag & Drop oder Dateiauswahl
  2. Klassen-Filter mit Checkboxen (mehrere auswählbar)
  3. CSV-Export mit Erfolgs-Nachricht

- **Modernes macOS Design**:
  - SwiftUI mit SF Symbols
  - Dark Mode / Light Mode Support
  - Liquid Design mit abgerundeten Ecken
  - Animierte Übergänge zwischen Schritten
  - Apple's neuestes Design System

- **Benutzerfreundlich**:
  - Drag & Drop Unterstützung
  - Echtzeit-Statistiken (Anzahl Klassen, Einträge)
  - Klare Fehlermeldungen
  - "Alle auswählen" / "Keine auswählen" Buttons

## Voraussetzungen

- **macOS 13.0 (Ventura) oder neuer**
- **Xcode 15.0 oder neuer**
- Grundlegende Kenntnisse in Xcode

## Installation & Setup

### Schritt 1: Xcode öffnen

1. Öffnen Sie **Xcode**
2. Wählen Sie **File → New → Project...**
3. Wählen Sie **macOS → App**
4. Klicken Sie auf **Next**

### Schritt 2: Projekt konfigurieren

Geben Sie folgende Informationen ein:

- **Product Name**: `TXTtoCSVConverter`
- **Team**: Ihr Apple Developer Team (oder "None")
- **Organization Identifier**: `com.yourname` (z.B. `com.schild`)
- **Bundle Identifier**: Wird automatisch generiert
- **Interface**: **SwiftUI**
- **Language**: **Swift**

Optionale Einstellungen (alle abwählen):
- [ ] Use Core Data
- [ ] Include Tests

Klicken Sie auf **Next** und wählen Sie einen Speicherort.

### Schritt 3: Dateien zum Projekt hinzufügen

1. Löschen Sie die automatisch erstellte `ContentView.swift` Datei (wird durch unsere ersetzt)

2. Erstellen Sie folgende Ordnerstruktur im Projekt:
   ```
   TXTtoCSVConverter/
   ├── TXTtoCSVConverterApp.swift
   ├── ContentView.swift
   ├── Models/
   │   ├── StudentRecord.swift
   │   └── ConversionManager.swift
   ├── Views/
   │   ├── FileDropView.swift
   │   ├── ClassFilterView.swift
   │   └── ExportView.swift
   └── Utils/
       ├── CSVParser.swift
       └── CSVWriter.swift
   ```

3. **Dateien hinzufügen**:

   Für jede Datei:
   - Rechtsklick auf den entsprechenden Ordner → **New File...**
   - Wählen Sie **Swift File**
   - Kopieren Sie den Inhalt aus den bereitgestellten `.swift` Dateien

   **WICHTIG**: Die Dateien befinden sich in:
   ```
   SwiftUI-App/TXTtoCSVConverter/
   ```

### Schritt 4: Projekt-Einstellungen anpassen

1. Klicken Sie auf das Projekt in der linken Seitenleiste
2. Wählen Sie das **Target** `TXTtoCSVConverter`
3. Gehen Sie zu **Signing & Capabilities**:
   - Wählen Sie Ihr **Team** (oder "Sign to Run Locally")
4. Gehen Sie zu **General**:
   - **Minimum Deployments**: macOS 13.0 oder höher

### Schritt 5: App-Icon (Optional)

1. Erstellen Sie ein App-Icon oder verwenden Sie ein Standard-Icon
2. Fügen Sie es zu **Assets.xcassets → AppIcon** hinzu

### Schritt 6: Build & Run

1. Wählen Sie **Product → Build** (⌘B)
2. Beheben Sie eventuelle Fehler (sollte keine geben)
3. Wählen Sie **Product → Run** (⌘R)
4. Die App startet!

## Nutzung der App

### Schritt 1: Datei auswählen

- **Option 1**: Ziehen Sie eine TXT-Datei auf die Drop-Zone
- **Option 2**: Klicken Sie auf "Datei auswählen" und wählen Sie eine TXT-Datei

Die Datei wird automatisch geladen und geparst.

### Schritt 2: Klassen filtern

- Die App zeigt alle gefundenen Klassen als Checkboxen
- Statistik oben: Anzahl gefundener/ausgewählter Klassen und Einträge
- **Alle auswählen**: Wählt alle Klassen
- **Keine auswählen**: Entfernt alle Auswahlen
- Wählen Sie die gewünschten Klassen durch Anklicken

### Schritt 3: Exportieren

- Überprüfen Sie die Zusammenfassung
- Klicken Sie auf **"CSV exportieren"**
- Wählen Sie einen Speicherort
- Die Datei wird als `[original]_converted.csv` vorgeschlagen
- Erfolgs-Nachricht zeigt Anzahl exportierter Zeilen

## Eingabe- und Ausgabeformat

### Eingabeformat (TXT)

```
"eindeutige Nummer (GUID)";"Nachname";"Vorname";"Klasse";"Allg. Adresse: Betreuer Name";"Allg. Adresse: Betreuer E-Mail"
"123-456";"Müller";"Hans";"10A";"Herr Schmidt";"schmidt@example.com"
```

- **Trennzeichen**: Semikolon (`;`)
- **Anführungszeichen**: Doppelte Anführungszeichen (`"`)
- **Encoding**: UTF-8

### Ausgabeformat (CSV)

- **Trennzeichen**: Tab (`\t`)
- **Encoding**: UTF-8
- **16 Spalten** (siehe Spalten-Mapping unten)

### Spalten-Mapping

| Eingabe (TXT)                        | Ausgabe (CSV)      |
|--------------------------------------|--------------------|
| eindeutige Nummer (GUID)             | studentExternalId  |
| Nachname                             | lastName           |
| Vorname                              | firstName          |
| Klasse                               | grade              |
| Allg. Adresse: Betreuer E-Mail       | email              |

**Leere Spalten in Ausgabe**: id, degree, postgrade, phone, mobile, displayRegisteredUserNames, externalKey, studentLastName, studentFirstName, studentShortName, studentInternalId

## Projektstruktur (Code-Übersicht)

```
TXTtoCSVConverter/
├── TXTtoCSVConverterApp.swift     # App Entry Point
├── ContentView.swift              # Haupt-View mit Schritt-Wechsel
├── Models/
│   ├── StudentRecord.swift        # Datenmodell für Einträge
│   └── ConversionManager.swift    # Business Logic & State Management
├── Views/
│   ├── FileDropView.swift         # Schritt 1: Datei-Upload
│   ├── ClassFilterView.swift      # Schritt 2: Klassen-Filter
│   └── ExportView.swift           # Schritt 3: Export & Erfolg
└── Utils/
    ├── CSVParser.swift            # Parser für TXT-Dateien
    └── CSVWriter.swift            # Writer für CSV-Dateien
```

## Technische Details

- **Framework**: SwiftUI (native macOS)
- **Mindest-macOS**: 13.0 (Ventura)
- **Programmiersprache**: Swift 5.9+
- **Architektur**: MVVM (Model-View-ViewModel)
- **State Management**: ObservableObject mit @Published
- **File I/O**: Foundation (FileManager, String encoding)

## App veröffentlichen (Optional)

### Für persönliche Nutzung (ohne App Store)

1. **Archive erstellen**:
   - Wählen Sie **Product → Archive**
   - Xcode erstellt ein Archive

2. **App exportieren**:
   - Klicken Sie auf **Distribute App**
   - Wählen Sie **Copy App**
   - Die `.app` Datei wird exportiert

3. **App installieren**:
   - Kopieren Sie die `.app` in den `Programme` Ordner
   - Bei Bedarf: Rechtsklick → Öffnen (beim ersten Mal)

### Für App Store (erfordert Developer Account)

1. Benötigen Sie ein **Apple Developer Account** ($99/Jahr)
2. Konfigurieren Sie **Signing & Capabilities** mit Ihrem Team
3. Erstellen Sie ein **Archive**
4. Wählen Sie **Distribute App → App Store Connect**
5. Folgen Sie dem Wizard

## Fehlerbehebung

### "Cannot find 'ConversionManager' in scope"

- Stellen Sie sicher, dass alle Dateien zum **Target** hinzugefügt sind
- Rechtsklick auf Datei → **Show File Inspector** → Target Membership muss aktiviert sein

### Build-Fehler wegen fehlender Imports

- Stellen Sie sicher, dass `import SwiftUI` und `import Foundation` in allen Dateien vorhanden sind

### App startet nicht

- Überprüfen Sie die **Minimum Deployment** Version (macOS 13.0+)
- Überprüfen Sie Signing & Capabilities

### Drag & Drop funktioniert nicht

- Überprüfen Sie die **App Sandbox** Einstellungen
- Eventuell müssen Sie **File Access** Berechtigungen hinzufügen

## Screenshots & Design

Die App verwendet:
- **SF Symbols**: `doc.text`, `checklist`, `checkmark.circle.fill`, etc.
- **SF Pro** Schriftart (System-Standard)
- **Accent Color**: System-Blau (kann angepasst werden)
- **Spacing**: Apple's HIG-konforme Abstände
- **Corner Radius**: 10-20pt für moderne Optik
- **Animations**: Spring-Animationen für Übergänge

## Support & Erweiterungen

### Mögliche Erweiterungen

- [ ] Mehrere Dateien gleichzeitig verarbeiten
- [ ] Vorschau der konvertierten Daten
- [ ] Eigenes Spalten-Mapping konfigurieren
- [ ] Export in andere Formate (Excel, JSON)
- [ ] Drag & Drop für Export
- [ ] Letzte Einstellungen speichern (UserDefaults)

### Hilfe

- Apple's SwiftUI Dokumentation: [developer.apple.com/swiftui](https://developer.apple.com/swiftui/)
- Human Interface Guidelines: [developer.apple.com/design/human-interface-guidelines/macos](https://developer.apple.com/design/human-interface-guidelines/macos)

## Lizenz

Dieses Projekt ist für den persönlichen und schulischen Gebrauch frei verfügbar.

---

**Viel Erfolg mit Ihrer macOS App!** 🎉
