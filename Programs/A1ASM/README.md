## Dokumentation
    •Projekt A1 mit createNewProjectASM.bat erstellt
    •Code aus main_w1.s in die main.s kopiert
    •Projekt in der CMSIS-Ansicht erfolgreich gebaut (Build)
    •Programm mit Load & Debug auf das Board übertragen und Debug Modus ausgeführt

    •Start: Zeile 29 (BL initITSboard; needed by the board to setup)
    •Breakpoint in Zeile 31 (LDR R6, =GPIO_D_SET; get address of the GPIO data set        register) gesetzt
    •Mit F5 (Continue) zum Breakpoint gesprungen.
    •Register-Beobachtung:
        •Beim Halt in Zeile 31 waren r0-r3, lr und pc im Register verändert(Board-Initialisierung)
        •Nach einem Schritt mit F10 (Step Over) wurde der Wert 0x40020c18 in r6 geladen.
        Bedeutung: Das ist die Adresse, um die LEDs auf dem Board einzuschalten.
        
    •LED-Verhalten und Kommentar-Überprüfung
        •Durchführung: Ich habe die Befehle von Zeile 39 bis 46 mit F10 (Step Over) ausgeführt und mit der Hardware abgeglichen.
        •Ergebnis: Alle Kommentare (z. B. switch on LED D14) sind korrekt. Die LEDs auf dem Board reagieren exakt wie im Code beschrieben.
        •Endzustand: Nach Ablauf aller Befehle leuchten nur noch die LEDs D08 und D09.

    •Optimierung des Quelltextes
        •Kommentar in Zeile 6 geändert von "three" zu "two" geändert
        •Ursprüngliche Schaltbefehle in Zeile 39-46 durch Voranstellen von ";" deaktiviert
        •Kombinierte Maske 0x03 (0x01 + 0x02) berechnet, um D08 und D09 gleichzeitig anzusteuern
        •Neuen Befehl MOV R0, #0x03 direkt vor dem Schaltvorgang eingefügt
        •Schaltbefehl STRB R0, [R6] ergänzt, um beide LEDs zeitgleich zu aktivieren
        •Erfolgreicher Testlauf im Debug Modus: Der Endzustand wird ohne Zwischenschritte sofort erreicht
        •Endlosschleife "b ." sorgt für einen stabilen Anzeigezustand am Programmanhalt