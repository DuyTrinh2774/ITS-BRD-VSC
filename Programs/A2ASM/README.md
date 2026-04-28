Dokumentation Aufgabenblatt 02
    Vorbereitung & Build:
        •Projekt erstellt als A2 mit createNewProjectASM.bat.
        •Die Datei main.s wurde vollständig durch den Quelltext aus main_w2.s ersetzt.
        •Start bei BL initITSboard im Debug-Modus.
        •Im GDB Memory Browser wurde die Location: VariableA bei Adress: 0x2000000c mit der Einstellung Bytes Per Group = 1 beobachtet

    Beobachtung:    
        •Anw01-03: R0 erhält die Basisadresse; R2 und R3 laden die Einzelbytes 0xEF und 0xBE.
        •Anw04-05: R2 wird durch Bit-Verschiebung (LSL) und ODER-Verknüpfung (ORR) zu 0xEFBE kombiniert
        •Anw06: Erst der strh-Befehl schreibt den Wert zurück. Der Speicher an 0x2000000C wechselt zu be ef – die Bytes wurden effektiv vertauscht.
