-- TXT zu CSV Konverter - AppleScript Droplet
-- Drag & Drop eine oder mehrere TXT-Dateien auf dieses Programm

on open droppedItems
	-- Pfad zum Python-Skript bestimmen (liegt im gleichen Ordner wie die App)
	set appPath to path to me as text
	set AppleScript's text item delimiters to ":"
	set pathItems to text items of appPath
	set AppleScript's text item delimiters to ""

	-- Entferne den App-Namen vom Pfad
	set appFolder to (items 1 thru -2 of pathItems) as text
	set pythonScriptPath to appFolder & ":convert_txt_to_csv.py"

	-- Konvertiere zu POSIX-Pfad
	set pythonScriptPOSIX to POSIX path of (pythonScriptPath as alias)

	-- Zähler für Statistik
	set totalFiles to 0
	set successFiles to 0
	set failedFiles to 0
	set totalRows to 0

	-- Verarbeite jede gedropte Datei
	repeat with currentFile in droppedItems
		set totalFiles to totalFiles + 1
		set filePath to POSIX path of currentFile

		try
			-- Prüfe ob es eine TXT-Datei ist
			if filePath ends with ".txt" then
				-- Python-Skript aufrufen
				set pythonCommand to "python3 " & quoted form of pythonScriptPOSIX & " " & quoted form of filePath
				set scriptOutput to do shell script pythonCommand

				-- Extrahiere Anzahl der Zeilen aus der Ausgabe
				try
					set AppleScript's text item delimiters to "Zeilen:   "
					set outputParts to text items of scriptOutput
					if (count of outputParts) > 1 then
						set rowsText to item 2 of outputParts
						set AppleScript's text item delimiters to return
						set rowsValue to text item 1 of rowsText
						set totalRows to totalRows + (rowsValue as integer)
					end if
					set AppleScript's text item delimiters to ""
				end try

				set successFiles to successFiles + 1
			else
				display dialog "Die Datei ist keine TXT-Datei:" & return & filePath buttons {"OK"} default button 1 with icon caution
				set failedFiles to failedFiles + 1
			end if
		on error errMsg
			display dialog "Fehler bei der Konvertierung:" & return & filePath & return & return & errMsg buttons {"OK"} default button 1 with icon stop
			set failedFiles to failedFiles + 1
		end try
	end repeat

	-- Erfolgsmeldung anzeigen
	if successFiles > 0 then
		set successMessage to "✓ Konvertierung abgeschlossen!" & return & return
		set successMessage to successMessage & "Erfolgreich: " & successFiles & " Datei(en)" & return
		if totalRows > 0 then
			set successMessage to successMessage & "Zeilen gesamt: " & totalRows & return
		end if
		if failedFiles > 0 then
			set successMessage to successMessage & "Fehlgeschlagen: " & failedFiles & " Datei(en)"
		end if

		display dialog successMessage buttons {"OK"} default button 1 with icon note giving up after 5
	else
		display dialog "Es wurden keine Dateien konvertiert." buttons {"OK"} default button 1 with icon caution
	end if
end open

-- Zeige Hinweis, wenn die App direkt geöffnet wird
on run
	display dialog "TXT zu CSV Konverter" & return & return & "Verwendung:" & return & "Ziehen Sie eine oder mehrere TXT-Dateien auf dieses Programm." & return & return & "Die konvertierten CSV-Dateien werden im gleichen Ordner erstellt." buttons {"OK"} default button 1 with icon note
end run
