#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
TXT zu CSV Konverter
Konvertiert eine semikolon-getrennte TXT-Datei in eine tab-getrennte CSV-Datei mit UTF-8 Encoding.
"""

import csv
import sys
import os
from pathlib import Path


def convert_txt_to_csv(input_file, output_file=None):
    """
    Konvertiert eine TXT-Datei in das gewünschte CSV-Format.

    Args:
        input_file: Pfad zur Eingabe-TXT-Datei
        output_file: Pfad zur Ausgabe-CSV-Datei (optional, wird automatisch generiert wenn nicht angegeben)
    """
    # Ausgabedatei automatisch generieren, wenn nicht angegeben
    if output_file is None:
        input_path = Path(input_file)
        output_file = input_path.parent / f"{input_path.stem}_converted.csv"

    # Mapping der Spalten: alter Name -> neuer Name
    column_mapping = {
        "eindeutige Nummer (GUID)": "studentExternalId",
        "Nachname": "lastName",
        "Vorname": "firstName",
        "Klasse": "grade",
        "Allg. Adresse: Betreuer E-Mail": "email"
    }

    # Vollständige Liste der Zielspalten
    target_columns = [
        "id", "lastName", "firstName", "degree", "grade", "postgrade",
        "email", "phone", "mobile", "displayRegisteredUserNames",
        "externalKey", "studentLastName", "studentFirstName",
        "studentShortName", "studentInternalId", "studentExternalId"
    ]

    try:
        # TXT-Datei lesen
        with open(input_file, 'r', encoding='utf-8') as infile:
            # Semikolon-getrennte Werte lesen
            reader = csv.DictReader(infile, delimiter=';', quotechar='"')

            # Daten transformieren
            transformed_data = []
            for row in reader:
                new_row = {}

                # Alle Zielspalten mit leeren Werten initialisieren
                for col in target_columns:
                    new_row[col] = ""

                # Vorhandene Werte aus der Quelldatei mappen
                for old_col, new_col in column_mapping.items():
                    if old_col in row and row[old_col]:
                        new_row[new_col] = row[old_col].strip()

                transformed_data.append(new_row)

        # CSV-Datei schreiben
        with open(output_file, 'w', encoding='utf-8', newline='') as outfile:
            # Tab-getrennte Werte schreiben
            writer = csv.DictWriter(outfile, fieldnames=target_columns, delimiter='\t')
            writer.writeheader()
            writer.writerows(transformed_data)

        print(f"✓ Konvertierung erfolgreich!")
        print(f"  Eingabe:  {input_file}")
        print(f"  Ausgabe:  {output_file}")
        print(f"  Zeilen:   {len(transformed_data)}")

    except FileNotFoundError:
        print(f"✗ Fehler: Datei '{input_file}' nicht gefunden!", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"✗ Fehler bei der Konvertierung: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    """Hauptfunktion für die Kommandozeilennutzung."""
    if len(sys.argv) < 2:
        print("Verwendung:")
        print(f"  python {os.path.basename(__file__)} <eingabe.txt> [ausgabe.csv]")
        print()
        print("Beispiele:")
        print(f"  python {os.path.basename(__file__)} daten.txt")
        print(f"  python {os.path.basename(__file__)} daten.txt ergebnis.csv")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    convert_txt_to_csv(input_file, output_file)


if __name__ == "__main__":
    main()
