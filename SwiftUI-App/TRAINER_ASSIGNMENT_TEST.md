# Test-Dokumentation: BVB Ausbilder-Zuordnung

## Feature-Übersicht

Dieses Feature ermöglicht die Zuordnung mehrerer Ausbilder-E-Mail-Adressen zu BVB-Klassen mit automatischer Datensatz-Duplizierung.

---

## Test-Workflow

### Schritt 1: Datei-Upload

**Beispiel TXT-Datei** (`test_bvb_daten.txt`):
```
eindeutige Nummer (GUID);Nachname;Vorname;Klasse;Allg. Adresse: Betreuer Name;Allg. Adresse: Betreuer E-Mail
{D05AFE02-6FE7-4289-AC65-88DF42029AF2};Beddoes;Justin;BVB1;Mader;mader@bkh-handwerk.de
{B123-4567-89AB-CDEF};Müller;Anna;BVB1;Mader;mader@bkh-handwerk.de
{C456-7890-ABCD-EF12};Schmidt;Peter;BVB2;Schmidt;schmidt@example.de
{D789-0ABC-DEF1-2345};Weber;Lisa;BVB2;Schmidt;schmidt@example.de
{E012-3456-789A-BCDE};Fischer;Tom;10A;Meier;meier@school.de
```

**Erwartetes Verhalten:**
- ✅ Datei wird erfolgreich geladen
- ✅ 5 Datensätze werden geparst
- ✅ ConversionManager.allRecords enthält 5 Einträge
- ✅ ConversionManager.availableClasses = ["BVB1", "BVB2", "10A"]

---

### Schritt 2: Klassen-Filter

**Benutzer-Aktion:**
- Wählt "BVB1", "BVB2", "10A" aus

**Erwartetes Verhalten:**
- ✅ ConversionManager.selectedClasses = ["BVB1", "BVB2", "10A"]
- ✅ ConversionManager.hasBVBClasses = `true`
- ✅ "Weiter"-Button ruft `goToConversion()` auf
- ✅ `goToConversion()` erkennt BVB-Klassen → leitet zu `trainerAssignment` weiter

---

### Schritt 3: Ausbilder-Zuordnung (NEU!)

#### 3.1 Initial State

**View-Anzeige:**
```
📊 Statistiken:
- BVB-Klassen: 2         (BVB1, BVB2)
- Ausbilder: 2           (mader@bkh-handwerk.de, schmidt@example.de)
- Zuordnungen: 0         (keine Mappings)
- Datensätze: 4          (4 BVB-Records)
```

**Computed Properties Test:**
```swift
manager.bvbClasses
// Erwartet: ["BVB1", "BVB2"]

manager.bvbRecords.count
// Erwartet: 4 (Justin, Anna, Peter, Lisa)

manager.uniqueTrainerEmails
// Erwartet: ["mader@bkh-handwerk.de", "schmidt@example.de"]

manager.trainerMappings
// Erwartet: [:] (leer)
```

#### 3.2 Suchfunktion Test

**Benutzer-Aktion:**
- Gibt "mader" in Suchfeld ein

**Erwartetes Verhalten:**
- ✅ filteredTrainers = ["mader@bkh-handwerk.de"]
- ✅ Liste zeigt nur 1 Ausbilder
- ✅ "2 Datensatz**e**" wird angezeigt (Justin + Anna)

**Benutzer-Aktion:**
- Löscht Suchfeld (X-Button)

**Erwartetes Verhalten:**
- ✅ filteredTrainers = ["mader@bkh-handwerk.de", "schmidt@example.de"]
- ✅ Liste zeigt wieder 2 Ausbilder

#### 3.3 E-Mail-Zuordnung Test

**Benutzer-Aktion:**
1. Klickt "+ E-Mail hinzufügen" bei "mader@bkh-handwerk.de"
2. Dialog öffnet sich

**Dialog-Anzeige:**
```
📧 E-Mail-Adresse hinzufügen
Für: mader@bkh-handwerk.de

[Neue E-Mail-Adresse]
[z.B. b.rajner@dobeq.de    ]

Oder aus Liste wählen:
○ schmidt@example.de
```

**Benutzer-Aktion:**
- Tippt "b.rajner@dobeq.de" ein
- Klickt "Hinzufügen"

**Erwartetes Verhalten:**
```swift
manager.trainerMappings
// Erwartet: ["mader@bkh-handwerk.de": ["b.rajner@dobeq.de"]]

manager.getAdditionalEmails(for: "mader@bkh-handwerk.de")
// Erwartet: ["b.rajner@dobeq.de"]
```

**UI-Update:**
- ✅ Dialog schließt sich
- ✅ TrainerRow zeigt jetzt Email-Tag: "b.rajner@dobeq.de" mit X-Button
- ✅ Statistik-Update:
  - Zuordnungen: **1**
  - Datensätze: **6** (4 original + 2 Duplikate)

#### 3.4 Weitere Zuordnung

**Benutzer-Aktion:**
1. Klickt "+ E-Mail hinzufügen" bei "mader@bkh-handwerk.de" erneut
2. Wählt "schmidt@example.de" aus Liste
3. Klickt "Hinzufügen"

**Erwartetes Verhalten:**
```swift
manager.trainerMappings
// Erwartet: ["mader@bkh-handwerk.de": ["b.rajner@dobeq.de", "schmidt@example.de"]]
```

**UI-Update:**
- ✅ 2 Email-Tags angezeigt
- ✅ Statistik:
  - Zuordnungen: **2**
  - Datensätze: **8** (4 original + 4 Duplikate)

#### 3.5 Zuordnung entfernen

**Benutzer-Aktion:**
- Klickt X bei "schmidt@example.de" Tag

**Erwartetes Verhalten:**
```swift
manager.removeEmailMapping(from: "mader@bkh-handwerk.de", email: "schmidt@example.de")

manager.trainerMappings
// Erwartet: ["mader@bkh-handwerk.de": ["b.rajner@dobeq.de"]]
```

**UI-Update:**
- ✅ Tag verschwindet (mit Animation)
- ✅ Statistik zurück:
  - Zuordnungen: **1**
  - Datensätze: **6**

#### 3.6 Navigation

**3 Button-Optionen:**

1. **"Zurück"**
   - Geht zu `classFilter`
   - Mappings bleiben erhalten

2. **"Überspringen"**
   - Ruft `skipTrainerAssignment()` auf
   - Geht direkt zu `conversion`
   - **KEINE Duplizierung** (processedRecords bleibt leer)

3. **"Weiter"** ✅
   - Ruft `applyTrainerMappings()` auf
   - Dupliziert Datensätze
   - Geht zu `conversion`

---

### Schritt 4: Datensatz-Duplizierung

**Benutzer-Aktion:**
- Klickt "Weiter"

**applyTrainerMappings() Logik:**

```swift
// Input:
filteredRecords = [
  {guid: D05AFE02..., lastName: Beddoes, firstName: Justin, className: BVB1, email: mader@...},
  {guid: B123..., lastName: Müller, firstName: Anna, className: BVB1, email: mader@...},
  {guid: C456..., lastName: Schmidt, firstName: Peter, className: BVB2, email: schmidt@...},
  {guid: D789..., lastName: Weber, firstName: Lisa, className: BVB2, email: schmidt@...},
  {guid: E012..., lastName: Fischer, firstName: Tom, className: 10A, email: meier@...}
]

trainerMappings = {
  "mader@bkh-handwerk.de": ["b.rajner@dobeq.de"]
}

// Schritt 1: Finde betroffene Datensätze
recordsToProcess = filteredRecords.filter { $0.supervisorEmail == "mader@bkh-handwerk.de" }
// → [Beddoes/Justin, Müller/Anna]

// Schritt 2: Dupliziere für jede zusätzliche E-Mail
for additionalEmail in ["b.rajner@dobeq.de"] {
  for record in recordsToProcess {
    var duplicate = record
    duplicate.supervisorEmail = "b.rajner@dobeq.de"
    result.append(duplicate)
  }
}

// Output:
processedRecords = [
  // Original 5 Datensätze
  {guid: D05AFE02..., lastName: Beddoes, firstName: Justin, className: BVB1, email: mader@...},
  {guid: B123..., lastName: Müller, firstName: Anna, className: BVB1, email: mader@...},
  {guid: C456..., lastName: Schmidt, firstName: Peter, className: BVB2, email: schmidt@...},
  {guid: D789..., lastName: Weber, firstName: Lisa, className: BVB2, email: schmidt@...},
  {guid: E012..., lastName: Fischer, firstName: Tom, className: 10A, email: meier@...},

  // Duplikate (2 neue)
  {guid: D05AFE02..., lastName: Beddoes, firstName: Justin, className: BVB1, email: b.rajner@dobeq.de},
  {guid: B123..., lastName: Müller, firstName: Anna, className: BVB1, email: b.rajner@dobeq.de}
]
```

**Wichtige Details:**
- ✅ GUID bleibt **identisch** (wichtig für Schild-NRW)
- ✅ Nur `supervisorEmail` ändert sich
- ✅ Alle anderen Felder bleiben gleich
- ✅ Nicht-BVB Datensätze (10A) bleiben unverändert

---

### Schritt 5: Export

**Benutzer-Aktion:**
- Klickt "CSV speichern"

**Erwartetes Verhalten:**
```swift
manager.finalRecords
// Falls processedRecords NICHT leer: Verwendet processedRecords (7 Datensätze)
// Falls processedRecords leer: Verwendet filteredRecords (5 Datensätze)

CSVWriter.write(records: finalRecords, to: url)
```

**Export-CSV** (Tab-getrennt, UTF-8):
```
id	lastName	firstName	degree	grade	postgrade	email	phone	mobile	displayRegisteredUserNames	externalKey	studentLastName	studentFirstName	studentShortName	studentInternalId	studentExternalId
	Beddoes	Justin			BVB1		mader@bkh-handwerk.de								{D05AFE02-6FE7-4289-AC65-88DF42029AF2}
	Müller	Anna			BVB1		mader@bkh-handwerk.de								{B123-4567-89AB-CDEF}
	Schmidt	Peter			BVB2		schmidt@example.de								{C456-7890-ABCD-EF12}
	Weber	Lisa			BVB2		schmidt@example.de								{D789-0ABC-DEF1-2345}
	Fischer	Tom			10A		meier@school.de								{E012-3456-789A-BCDE}
	Beddoes	Justin			BVB1		b.rajner@dobeq.de								{D05AFE02-6FE7-4289-AC65-88DF42029AF2}
	Müller	Anna			BVB1		b.rajner@dobeq.de								{B123-4567-89AB-CDEF}
```

**Erfolgs-Anzeige:**
```
✓ Erfolgreich exportiert!

7 Zeile(n) wurden konvertiert.
```

---

## Edge Cases & Validierung

### 1. Keine BVB-Klassen ausgewählt

**Szenario:**
- Benutzer wählt nur "10A", "11B"

**Erwartetes Verhalten:**
- ✅ `manager.hasBVBClasses` = `false`
- ✅ `goToConversion()` überspringt `trainerAssignment`
- ✅ Geht direkt von `classFilter` → `conversion`

### 2. Leere E-Mail-Eingabe

**Szenario:**
- Dialog öffnet, Benutzer klickt "Hinzufügen" ohne Eingabe

**Erwartetes Verhalten:**
- ✅ Button ist disabled (`.disabled(newEmail.isEmpty)`)
- ✅ Button hat Opacity 0.5
- ✅ Klick hat keine Wirkung

### 3. Doppelte Zuordnung

**Szenario:**
- Benutzer fügt "b.rajner@dobeq.de" hinzu
- Versucht erneut "b.rajner@dobeq.de" hinzuzufügen

**Erwartetes Verhalten:**
```swift
if !trainerMappings[originalEmail]!.contains(additionalEmail) {
    trainerMappings[originalEmail]!.append(additionalEmail)
}
```
- ✅ Duplikat wird NICHT hinzugefügt
- ✅ Liste zeigt nur einmal "b.rajner@dobeq.de"

### 4. Trainer ohne Datensätze

**Szenario:**
- Alle Datensätze einer E-Mail werden gefiltert (z.B. Klasse nicht ausgewählt)

**Erwartetes Verhalten:**
- ✅ Trainer erscheint trotzdem in Liste (falls in anderen BVB-Klassen)
- ✅ "0 Datensätze" wird angezeigt
- ✅ Zuordnung möglich, aber keine Duplizierung

### 5. Überspringen vs. Weiter

**Szenario A - "Überspringen":**
```swift
manager.skipTrainerAssignment()
// → currentStep = .conversion
// → processedRecords bleibt LEER
// → finalRecords = filteredRecords (Original-Daten)
```

**Szenario B - "Weiter" ohne Mappings:**
```swift
manager.applyTrainerMappings()
// trainerMappings = [:] (leer)
// → Schleife läuft nicht
// → processedRecords = filteredRecords (Kopie)
// → finalRecords = processedRecords
// → GLEICHER Export wie "Überspringen"
```

### 6. Mehrere Zuordnungen pro Trainer

**Szenario:**
- Trainer A → [Email1, Email2, Email3]

**Erwartetes Verhalten:**
```swift
recordsForTrainerA = 5 Datensätze
additionalEmails = 3
→ Duplikate = 5 × 3 = 15 neue Datensätze
→ Gesamt = 5 + 15 = 20 Datensätze
```

---

## Code-Überprüfung

### ConversionManager.swift

**Kritische Funktionen:**

✅ **applyTrainerMappings()**
```swift
func applyTrainerMappings() {
    isProcessing = true  // ← Zeigt Loading-Overlay
    errorMessage = nil

    var result: [StudentRecord] = filteredRecords  // ← Start mit Original

    for (originalEmail, additionalEmails) in trainerMappings {
        let recordsToProcess = result.filter { $0.supervisorEmail == originalEmail }

        for additionalEmail in additionalEmails {
            for record in recordsToProcess {
                var duplicate = record  // ← Kopiert ALLE Felder (inkl. GUID!)
                duplicate.supervisorEmail = additionalEmail  // ← Ändert nur E-Mail
                result.append(duplicate)
            }
        }
    }

    processedRecords = result  // ← Speichert Ergebnis
    isProcessing = false
}
```

✅ **finalRecords**
```swift
var finalRecords: [StudentRecord] {
    processedRecords.isEmpty ? filteredRecords : processedRecords
}
// ← Export verwendet IMMER finalRecords
```

### TrainerAssignmentView_Tahoe.swift

**Kritische UI-Elemente:**

✅ **Statistik berechnet korrekt:**
```swift
private var estimatedRecordCount: Int {
    let originalCount = manager.bvbRecords.count
    var duplicates = 0

    for (email, additionalEmails) in manager.trainerMappings {
        let recordsForEmail = manager.bvbRecords.filter { $0.supervisorEmail == email }.count
        duplicates += recordsForEmail * additionalEmails.count
    }

    return originalCount + duplicates
}
```

✅ **Suchfilter funktioniert:**
```swift
private var filteredTrainers: [String] {
    if searchText.isEmpty {
        return manager.uniqueTrainerEmails
    } else {
        return manager.uniqueTrainerEmails.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
}
```

---

## Performance-Tests

### Skalierung

**Kleiner Datensatz:**
- 10 BVB-Datensätze
- 2 Trainer
- 1 Mapping mit 1 Zusatz-Email
- → **Ergebnis:** 10 + 5 = 15 Datensätze
- ⏱️ **Erwartete Zeit:** < 1ms

**Mittlerer Datensatz:**
- 100 BVB-Datensätze
- 10 Trainer
- 3 Mappings mit je 2 Zusatz-Emails
- → **Ergebnis:** 100 + 60 = 160 Datensätze
- ⏱️ **Erwartete Zeit:** < 10ms

**Großer Datensatz:**
- 1000 BVB-Datensätze
- 50 Trainer
- 10 Mappings mit je 3 Zusatz-Emails
- → **Ergebnis:** 1000 + 600 = 1600 Datensätze
- ⏱️ **Erwartete Zeit:** < 100ms

**Algorithmus-Komplexität:**
- Zeit: O(n × m × k)
  - n = Anzahl Mappings
  - m = Datensätze pro Trainer
  - k = Zusatz-Emails pro Mapping
- Speicher: O(n × m × k) für Duplikate

---

## UI/UX Tests

### Animationen

✅ **View-Erscheinen:**
- 0.1s Delay → Header Icon skaliert
- 0.2s Delay → Statistik-Cards faden ein
- Staggered: TrainerRows erscheinen nacheinander (0.05s × Index)

✅ **Interaktionen:**
- Email-Tag entfernen: Spring-Animation
- Dialog öffnen: Sheet-Transition
- Navigation: Asymmetrische Slide-Transition

### Accessibility

✅ **VoiceOver-Support:**
- Buttons haben klar beschriftete Labels
- Statistik-Werte sind lesbar
- Suchfeld hat Placeholder

✅ **Keyboard-Navigation:**
- Tab zwischen Buttons
- Enter in Suchfeld fokussiert Ergebnisse
- Esc schließt Dialog

---

## Regressions-Tests

### Bestehende Funktionen bleiben intakt

✅ **Normale Klassen (ohne BVB):**
- Workflow: FileUpload → ClassFilter → **Export** (überspringt Trainer)
- Export verwendet `filteredRecords` direkt

✅ **Gemischte Auswahl (BVB + Normal):**
- BVB-Datensätze werden dupliziert
- Normale Datensätze bleiben unverändert
- Beide im selben CSV-Export

✅ **Reset-Funktion:**
```swift
func reset() {
    // ...
    trainerMappings = [:]       // ← Löscht Mappings
    processedRecords = []       // ← Löscht Duplikate
}
```

---

## Checkliste für manuellen Test

### Pre-Test Setup
- [ ] Xcode 15.0+ installiert
- [ ] macOS 14.0+ (für Tahoe Design)
- [ ] Projekt in Xcode öffnen
- [ ] Build erfolgreich (⌘+B)

### Test-Durchlauf

**1. Datei-Upload**
- [ ] TXT-Datei mit BVB-Klassen laden
- [ ] Parser erkennt BVB1, BVB2, BVB3
- [ ] Alle Datensätze korrekt eingelesen

**2. Klassen-Filter**
- [ ] BVB-Klassen sind sichtbar
- [ ] BVB-Klassen auswählbar
- [ ] "Weiter" führt zu TrainerAssignment (nicht direkt Export!)

**3. TrainerAssignment View**
- [ ] Header zeigt BVB-Klassen
- [ ] Statistik zeigt korrekte Zahlen
- [ ] Suchfeld funktioniert
- [ ] Alle Trainer werden angezeigt
- [ ] Datensatz-Anzahl pro Trainer korrekt

**4. E-Mail-Zuordnung**
- [ ] "+ E-Mail hinzufügen" öffnet Dialog
- [ ] Freie Eingabe möglich
- [ ] Auswahl aus Liste möglich
- [ ] "Hinzufügen" speichert Mapping
- [ ] Email-Tag erscheint
- [ ] Statistik aktualisiert sich

**5. Zuordnung entfernen**
- [ ] X-Button auf Tag sichtbar
- [ ] Klick entfernt Zuordnung
- [ ] Tag verschwindet
- [ ] Statistik aktualisiert sich

**6. Navigation**
- [ ] "Zurück" funktioniert
- [ ] "Überspringen" geht zu Export
- [ ] "Weiter" dupliziert Datensätze

**7. Export**
- [ ] CSV enthält Original-Datensätze
- [ ] CSV enthält duplizierte Datensätze
- [ ] GUIDs sind identisch
- [ ] Nur E-Mail ist unterschiedlich
- [ ] Tab-getrennt
- [ ] UTF-8 Encoding

---

## Bekannte Einschränkungen

1. **Swift-Compiler nicht verfügbar in Test-Umgebung**
   - Code kann nicht kompiliert werden
   - Nur statische Code-Analyse möglich

2. **SwiftUI-Preview möglicherweise nicht funktional**
   - #Preview benötigt Xcode 15+
   - Läuft nur auf macOS

3. **Keine Unit-Tests implementiert**
   - Feature ist manuell testbar
   - Unit-Tests könnten hinzugefügt werden

---

## Erwartete Ergebnisse

### ✅ Erfolg-Kriterien

1. **Funktionalität:**
   - Duplizierung funktioniert korrekt
   - GUID bleibt identisch
   - Workflow ist intuitiv

2. **Performance:**
   - Schnelle Verarbeitung (< 100ms für 1000 Records)
   - UI bleibt responsive

3. **Design:**
   - Konsistent mit Tahoe Liquid Glass
   - Animationen sind flüssig
   - Layout ist responsiv

4. **Stabilität:**
   - Keine Crashes
   - Korrekte Error-Handling
   - Edge Cases funktionieren

---

## Nächste Schritte

1. **Manueller Test in Xcode**
   - App builden und ausführen
   - Mit realen BVB-Daten testen
   - Export-CSV in Schild-NRW importieren

2. **Feedback sammeln**
   - Benutzer-Feedback zur UX
   - Performance-Messung
   - Verbesserungsvorschläge

3. **Iteration**
   - Bugfixes basierend auf Tests
   - Feature-Erweiterungen falls nötig

---

**Status:** ✅ Implementation abgeschlossen, bereit für manuellen Test
**Version:** 1.0
**Letztes Update:** 2025-11-21
