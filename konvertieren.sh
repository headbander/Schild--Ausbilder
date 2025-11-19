#!/bin/bash
# TXT zu CSV Konverter - Mac/Linux Shell-Skript
# Verwendung: ./konvertieren.sh eingabe.txt

if [ -z "$1" ]; then
    echo "Bitte geben Sie eine TXT-Datei an:"
    echo "  ./konvertieren.sh eingabe.txt"
    exit 1
fi

python3 convert_txt_to_csv.py "$1"
