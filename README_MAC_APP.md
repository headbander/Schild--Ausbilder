# TXT zu CSV Konverter - Mac App (Droplet)

Eine macOS-Anwendung zum einfachen Konvertieren von semikolon-getrennten TXT-Dateien in tab-getrennte CSV-Dateien per Drag & Drop.

## Voraussetzungen

- **macOS** (getestet ab macOS 10.13)
- **Python 3** muss installiert sein

### Python 3 Installation prüfen

Öffnen Sie das Terminal und geben Sie ein:

```bash
python3 --version
```

Falls Python 3 nicht installiert ist:
1. Besuchen Sie [python.org/downloads](https://www.python.org/downloads/)
2. Laden Sie die neueste Python 3 Version für macOS herunter
3. Installieren Sie Python 3

Alternativ mit Homebrew:
```bash
brew install python3
```

## Installation

### Option 1: Automatische Installation (empfohlen)

1. Laden Sie alle Dateien in einen Ordner herunter
2. Öffnen Sie das Terminal
3. Navigieren Sie zum Ordner:
   ```bash
   cd /pfad/zum/ordner
   ```
4. Führen Sie das Build-Skript aus:
   ```bash
   ./build_mac_app.sh
   ```

Das Skript erstellt die App `TXT zu CSV Konverter.app` automatisch.

### Option 2: Manuelle Installation mit Script Editor

1. Öffnen Sie `TXT_zu_CSV_Konverter.applescript` mit **Script Editor** (im Ordner Programme → Dienstprogramme)
2. Klicken Sie auf **Ablage → Exportieren...**
3. Wählen Sie:
   - **Dateiformat**: Application
   - **Name**: TXT zu CSV Konverter
   - **Speicherort**: Gewünschter Ordner
4. Klicken Sie auf **Sichern**

### Wichtig: Dateien zusammen behalten

Die folgenden Dateien müssen im **gleichen Ordner** liegen:
- `TXT zu CSV Konverter.app` (die erstellte App)
- `convert_txt_to_csv.py` (das Python-Skript)

Wenn Sie die App verschieben, verschieben Sie **beide Dateien** zusammen!

## Verwendung

### Drag & Drop (Hauptfunktion)

1. Ziehen Sie eine oder mehrere TXT-Dateien auf das App-Icon `TXT zu CSV Konverter.app`
2. Die App verarbeitet die Dateien automatisch
3. Eine Erfolgsmeldung zeigt die Anzahl der konvertierten Dateien und Zeilen
4. Die konvertierten CSV-Dateien finden Sie im **gleichen Ordner** wie die Original-TXT-Dateien

### Beispiel

Wenn Sie die Datei `schueler.txt` auf die App ziehen:
- **Eingabe**: `schueler.txt`
- **Ausgabe**: `schueler_converted.csv` (im gleichen Ordner)

### Mehrere Dateien gleichzeitig

Sie können mehrere TXT-Dateien gleichzeitig auf die App ziehen - sie werden alle nacheinander konvertiert.

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
- **Spalten** (in dieser Reihenfolge):
  - id
  - lastName
  - firstName
  - degree
  - grade
  - postgrade
  - email
  - phone
  - mobile
  - displayRegisteredUserNames
  - externalKey
  - studentLastName
  - studentFirstName
  - studentShortName
  - studentInternalId
  - studentExternalId

### Spalten-Mapping

| Eingabe (TXT)                        | Ausgabe (CSV)      |
|--------------------------------------|--------------------|
| eindeutige Nummer (GUID)             | studentExternalId  |
| Nachname                             | lastName           |
| Vorname                              | firstName          |
| Klasse                               | grade              |
| Allg. Adresse: Betreuer E-Mail       | email              |

Alle anderen Spalten bleiben leer.

## Fehlerbehebung

### "Die App kann nicht geöffnet werden, da sie von einem nicht verifizierten Entwickler stammt"

1. **Rechtsklick** (oder Ctrl+Klick) auf die App
2. Wählen Sie **Öffnen**
3. Klicken Sie im Dialog auf **Öffnen**
4. Ab jetzt können Sie die App normal verwenden

Oder über die Systemeinstellungen:
1. Öffnen Sie **Systemeinstellungen → Sicherheit**
2. Klicken Sie auf **Trotzdem öffnen**

### "python3: command not found"

Python 3 ist nicht installiert. Siehe Abschnitt "Voraussetzungen" oben.

### "convert_txt_to_csv.py nicht gefunden"

Das Python-Skript liegt nicht im gleichen Ordner wie die App. Stellen Sie sicher, dass beide Dateien im selben Ordner sind:
- `TXT zu CSV Konverter.app`
- `convert_txt_to_csv.py`

### Die App zeigt eine Fehlermeldung bei der Konvertierung

Prüfen Sie:
1. Ist die Datei wirklich eine TXT-Datei mit der Endung `.txt`?
2. Ist die Datei korrekt formatiert (semikolon-getrennt)?
3. Ist die Datei im UTF-8 Format gespeichert?

## Beispiel-Workflow

1. Sie haben eine Datei `meine_daten.txt` auf dem Desktop
2. Sie ziehen `meine_daten.txt` auf `TXT zu CSV Konverter.app`
3. Die App zeigt: "✓ Konvertierung abgeschlossen! Erfolgreich: 1 Datei(en), Zeilen gesamt: 150"
4. Auf dem Desktop finden Sie nun `meine_daten_converted.csv`

## Technische Details

- Die App ist ein AppleScript Droplet
- Sie ruft das Python-Skript `convert_txt_to_csv.py` auf
- Die Konvertierung erfolgt lokal auf Ihrem Mac
- Es werden keine Daten ins Internet übertragen

## Support

Bei Problemen oder Fragen:
1. Überprüfen Sie die Fehlerbehebung oben
2. Stellen Sie sicher, dass alle Voraussetzungen erfüllt sind
3. Testen Sie mit der mitgelieferten `beispiel.txt` Datei

## Alternative: Kommandozeile

Falls Sie die App nicht verwenden möchten, können Sie das Python-Skript auch direkt im Terminal verwenden:

```bash
python3 convert_txt_to_csv.py ihre_datei.txt
```

Siehe `README_CONVERTER.md` für weitere Details zur Kommandozeilen-Nutzung.
