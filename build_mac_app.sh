#!/bin/bash
# Build-Skript für Mac: Erstellt das "TXT zu CSV Konverter.app" Droplet

set -e  # Beende bei Fehler

echo "========================================="
echo "TXT zu CSV Konverter - Mac App Builder"
echo "========================================="
echo ""

# Prüfe ob wir auf einem Mac sind
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  Warnung: Dieses Skript sollte auf einem Mac ausgeführt werden."
    echo "   Das Kompilieren auf anderen Systemen wird nicht unterstützt."
    exit 1
fi

# Prüfe ob osacompile verfügbar ist
if ! command -v osacompile &> /dev/null; then
    echo "✗ Fehler: osacompile nicht gefunden."
    echo "  osacompile ist Teil von macOS und sollte standardmäßig verfügbar sein."
    exit 1
fi

# Prüfe ob Python 3 verfügbar ist
if ! command -v python3 &> /dev/null; then
    echo "✗ Fehler: python3 nicht gefunden."
    echo "  Bitte installieren Sie Python 3 von https://www.python.org/"
    exit 1
fi

echo "✓ Voraussetzungen erfüllt"
echo ""

# Lösche alte App falls vorhanden
if [ -d "TXT zu CSV Konverter.app" ]; then
    echo "→ Entferne alte Version..."
    rm -rf "TXT zu CSV Konverter.app"
fi

# Kompiliere AppleScript zu einer App
echo "→ Kompiliere AppleScript..."
osacompile -o "TXT zu CSV Konverter.app" TXT_zu_CSV_Konverter.applescript

# Setze das Stay-Open Flag, damit die App als Droplet funktioniert
echo "→ Konfiguriere als Droplet..."
defaults write "$(pwd)/TXT zu CSV Konverter.app/Contents/Info" NSUIElement -bool YES

# Kopiere das Python-Skript in den App-Ordner
echo "→ Kopiere Python-Skript..."
if [ -f "convert_txt_to_csv.py" ]; then
    # Das Python-Skript muss im gleichen Ordner wie die App sein
    # (wird vom AppleScript erwartet)
    echo "  (Python-Skript bleibt im Haupt-Ordner)"
else
    echo "✗ Fehler: convert_txt_to_csv.py nicht gefunden!"
    exit 1
fi

echo ""
echo "========================================="
echo "✓ Erfolgreich erstellt!"
echo "========================================="
echo ""
echo "Die App 'TXT zu CSV Konverter.app' wurde erstellt."
echo ""
echo "Installation:"
echo "  1. Kopieren Sie die App in einen Ordner Ihrer Wahl"
echo "  2. Stellen Sie sicher, dass 'convert_txt_to_csv.py' im"
echo "     gleichen Ordner wie die App liegt"
echo ""
echo "Verwendung:"
echo "  - Ziehen Sie TXT-Dateien auf die App"
echo "  - Die konvertierten CSV-Dateien werden im gleichen"
echo "    Ordner wie die Eingabedateien erstellt"
echo ""
