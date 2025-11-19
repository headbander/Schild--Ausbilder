# TXT zu CSV Konverter

Dieses Skript konvertiert semikolon-getrennte TXT-Dateien in tab-getrennte CSV-Dateien im UTF-8 Format.

## Voraussetzungen

- Python 3.6 oder höher muss installiert sein
- Das Skript funktioniert auf Mac, Windows und Linux

### Python-Installation prüfen

**Mac/Linux:**
```bash
python3 --version
```

**Windows:**
```cmd
python --version
```

Falls Python nicht installiert ist:
- **Mac:** Python ist meist vorinstalliert, ansonsten über [python.org](https://www.python.org/downloads/) installieren
- **Windows:** Von [python.org](https://www.python.org/downloads/) herunterladen und installieren

## Verwendung

### Mac/Linux

1. Terminal öffnen
2. Zum Ordner mit dem Skript navigieren:
   ```bash
   cd /pfad/zum/ordner
   ```

3. Skript ausführen:
   ```bash
   python3 convert_txt_to_csv.py eingabe.txt
   ```

   Oder mit eigenem Ausgabedateinamen:
   ```bash
   python3 convert_txt_to_csv.py eingabe.txt ausgabe.csv
   ```

### Windows

1. Eingabeaufforderung (CMD) oder PowerShell öffnen
2. Zum Ordner mit dem Skript navigieren:
   ```cmd
   cd C:\pfad\zum\ordner
   ```

3. Skript ausführen:
   ```cmd
   python convert_txt_to_csv.py eingabe.txt
   ```

   Oder mit eigenem Ausgabedateinamen:
   ```cmd
   python convert_txt_to_csv.py eingabe.txt ausgabe.csv
   ```

### Einfache Verwendung per Drag & Drop (Windows)

Sie können auch eine Batch-Datei erstellen:

1. Erstellen Sie eine neue Textdatei namens `konvertieren.bat` im selben Ordner
2. Fügen Sie folgenden Inhalt ein:
   ```batch
   @echo off
   python convert_txt_to_csv.py %1
   pause
   ```
3. Speichern und schließen
4. Ziehen Sie Ihre TXT-Datei auf die `konvertieren.bat`

### Einfache Verwendung per Drag & Drop (Mac)

Sie können auch ein Shell-Skript erstellen:

1. Erstellen Sie eine neue Textdatei namens `konvertieren.sh` im selben Ordner
2. Fügen Sie folgenden Inhalt ein:
   ```bash
   #!/bin/bash
   python3 convert_txt_to_csv.py "$1"
   ```
3. Speichern und schließen
4. Machen Sie das Skript ausführbar:
   ```bash
   chmod +x konvertieren.sh
   ```
5. Ziehen Sie Ihre TXT-Datei auf das `konvertieren.sh` im Terminal

## Eingabeformat

Die Eingabe-TXT-Datei sollte folgendes Format haben:

```
"eindeutige Nummer (GUID)";"Nachname";"Vorname";"Klasse";"Allg. Adresse: Betreuer Name";"Allg. Adresse: Betreuer E-Mail"
"123-456";"Müller";"Hans";"10A";"Herr Schmidt";"schmidt@example.com"
```

- Trennzeichen: Semikolon (`;`)
- Anführungszeichen: Doppelte Anführungszeichen (`"`)
- Encoding: UTF-8

## Ausgabeformat

Die Ausgabe-CSV-Datei hat folgendes Format:

- Trennzeichen: Tab (`\t`)
- Encoding: UTF-8
- Spalten (in dieser Reihenfolge):
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

## Spalten-Mapping

Das Skript führt folgende Zuordnung durch:

| Eingabe (TXT)                        | Ausgabe (CSV)      |
|--------------------------------------|--------------------|
| eindeutige Nummer (GUID)             | studentExternalId  |
| Nachname                             | lastName           |
| Vorname                              | firstName          |
| Klasse                               | grade              |
| Allg. Adresse: Betreuer E-Mail       | email              |

Alle anderen Spalten in der Ausgabe bleiben leer.

## Beispiel

```bash
python3 convert_txt_to_csv.py schueler.txt
```

Ausgabe:
```
✓ Konvertierung erfolgreich!
  Eingabe:  schueler.txt
  Ausgabe:  schueler_converted.csv
  Zeilen:   150
```

## Fehlerbehandlung

- Wenn die Eingabedatei nicht gefunden wird, erhalten Sie eine Fehlermeldung
- Wenn keine Eingabedatei angegeben wird, zeigt das Skript die Verwendungshinweise an
- Bei anderen Fehlern wird eine aussagekräftige Fehlermeldung angezeigt

## Hinweise

- Die Ausgabedatei wird immer im UTF-8 Format erstellt
- Vorhandene Ausgabedateien werden überschrieben
- Leerzeichen am Anfang und Ende der Werte werden automatisch entfernt
