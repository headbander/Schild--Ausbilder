@echo off
REM TXT zu CSV Konverter - Windows Batch-Datei
REM Verwendung: Ziehen Sie Ihre TXT-Datei auf diese Batch-Datei

if "%~1"=="" (
    echo Bitte ziehen Sie eine TXT-Datei auf diese Batch-Datei
    echo oder rufen Sie das Skript mit: konvertieren.bat eingabe.txt
    pause
    exit /b 1
)

python convert_txt_to_csv.py "%~1"
pause
