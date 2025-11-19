# Quick Start - TXT zu CSV Konverter (SwiftUI)

Schnellanleitung zum Einrichten der App in Xcode.

## 5-Minuten-Setup

### 1. Neues Xcode-Projekt erstellen

```
Xcode → File → New → Project
  → macOS → App
  → Name: TXTtoCSVConverter
  → Interface: SwiftUI
  → Language: Swift
```

### 2. Ordnerstruktur erstellen

Im Projekt-Navigator (links), erstellen Sie folgende Gruppen (Ordner):

- `Models` (Right-click → New Group)
- `Views` (Right-click → New Group)
- `Utils` (Right-click → New Group)

### 3. Dateien hinzufügen

Kopieren Sie die Swift-Dateien aus `TXTtoCSVConverter/` in Ihr Xcode-Projekt:

**Root-Level:**
- `TXTtoCSVConverterApp.swift` → Ersetzen Sie die bestehende Datei
- `ContentView.swift` → Ersetzen Sie die bestehende Datei

**Models-Ordner:**
- `StudentRecord.swift`
- `ConversionManager.swift`

**Views-Ordner:**
- `FileDropView.swift`
- `ClassFilterView.swift`
- `ExportView.swift`

**Utils-Ordner:**
- `CSVParser.swift`
- `CSVWriter.swift`

### 4. Build & Run

```
⌘B  → Build
⌘R  → Run
```

Fertig! 🎉

## Checkliste

- [ ] Xcode-Projekt erstellt (macOS App, SwiftUI)
- [ ] Ordner `Models`, `Views`, `Utils` erstellt
- [ ] Alle 9 Swift-Dateien hinzugefügt
- [ ] Minimum Deployment: macOS 13.0
- [ ] Build erfolgreich (⌘B)
- [ ] App läuft (⌘R)

## Häufige Fehler

### Fehler: "Cannot find 'X' in scope"

**Lösung**: Datei wurde nicht zum Target hinzugefügt
1. Klicken Sie auf die Datei im Navigator
2. Rechts: File Inspector
3. Aktivieren Sie `TXTtoCSVConverter` unter "Target Membership"

### Fehler: Build schlägt fehl

**Lösung**: Überprüfen Sie:
- Alle Dateien richtig benannt?
- Alle Dateien im Projekt sichtbar?
- macOS 13.0+ als Deployment Target?

## Testen

Verwenden Sie die Beispiel-Datei `beispiel.txt` aus dem Root-Ordner zum Testen:

1. App starten (⌘R)
2. Beispieldatei in die Drop-Zone ziehen
3. Klassen auswählen (z.B. "10A", "10B")
4. CSV exportieren
5. Datei öffnen und prüfen

## Nächste Schritte

Siehe `README_SWIFTUI.md` für:
- Detaillierte Projektstruktur
- Code-Erklärungen
- Erweiterungsmöglichkeiten
- App-Veröffentlichung
