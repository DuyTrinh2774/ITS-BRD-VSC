;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Silke Behn	
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main.
;					  :
;					  : Replace this main with yours.
;
;*******************************************************************************
    EXTERN initITSboard
    EXTERN lcdPrintS            ;Display ausgabe
    EXTERN GUI_init
;	EXTERN TP_Init

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 2
	
	    GLOBAL text
DEFAULT_BRIGHTNESS DCW  800
	
text	DCB	"Hallo liebes TI-Labor (asm-project)",0

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
	
main	PROC
        BL initITSboard
		ldr r1, =DEFAULT_BRIGHTNESS
		ldrh r0, [r1]
		bl GUI_init
		mov r0, #0x00
;		bl TP_Init
		
		LDR	r0,=text
        BL  lcdPrintS


; ==============================================================================
; PrimzahlSieb: GRAFISCHE DARSTELLUNG DES SPEICHERS
; ==============================================================================
; siebArray (Arbeitsfeld): Index = Zahl, Wert (Byte) = Status (1=Prim, 0=Gestrichen)
; Index:          0     1     2     3     4     5     6     7     ...  1000
;               +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
; Inhalt (Byte):|  0  |  0  |  1  |  1  |  0  |  1  |  0  |  1  | ... |  0  |
;               +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
;
; primzahlenArray (Ergebnis-Feld): Index dient zur Position, Inhalt = Primzahl (Int)
; Index:        [0]   [1]   [2]   [3]   [4]   ...
;               +-----+-----+-----+-----+-----+-----+
; Inhalt (Int): |  2  |  3  |  5  |  7  | 11  | ... |
;               +-----+-----+-----+-----+-----+-----+
; ==============================================================================

; ==============================================================================
; PrimzahlSieb: KOMMENTARE
; ==============================================================================

; --- 1. GEPLANTE SPEICHERBEREICHE (LABELS) ---
; Wir benötigen im RAM zwei konkrete Speicherbereiche:
    ; siebArray:        Ein zusammenhängender Speicher von 1001 Bytes (für Indizes 0 bis 1000).
    ;                   Jedes Byte steht für eine Zahl. Wert 1 = Primzahl, Wert 0 = Gestrichen.
    ; primzahlenArray:  Speicherbereich für die finalen, echten Primzahlen (z. B. als 2-Byte-Werte / Halfwords).

; --- 2. REGISTERPLANUNG ---
    ; r0 = Basisadresse des siebArray (Wo fängt das Sieb im Speicher an?)
    ; r1 = Obergrenze / Limit (Festwert: 1000) 
    ; r2 = Aktuelle Basis-Zahl 'p' in der äußeren Schleife (Startet bei 2) 
    ; r3 = Aktuelles Vielfaches 'i' in der inneren Schleife (Startet bei p * p) 
    ; r4 = Basisadresse des primzahlenArray (Wo werden die Ergebnisse gespeichert?)
    ; r5 = Ergebnis-Zähler (Wie viele Primzahlen haben wir schon gefunden?)
    ; r6 = Temporäres Hilfsregister, um Werte wie 0 oder 1 in den Speicher zu schreiben

; --- 3. TEILFUNKTION: INITIALISIERUNG (siebInit) ---
; Zu Beginn muss definiert werden, dass standardmäßig erst einmal jede Zahl eine Primzahl sein könnte.
    ; - Schleife läuft von Index 2 bis Index 1000.
    ; - In jedes Byte des siebArray wird der Wert 1 geschrieben (1 = wahr / ist Primzahl).
    ; - Die Indizes 0 und 1 werden explizit auf 0 gesetzt, da 0 und 1 per Definition keine Primzahlen sind.

; --- 4. TEILFUNKTION: SIEB-ALGORITHMUS (siebFunktion) ---
; Hauptlogik des Eratosthenes:
    ; - Äußere Schleife: Erhöhe p von 2 bis 1000.
    ; - Lade das Byte aus siebArray an der Stelle p.
    ; - PRÜFUNG: Ist das Byte gleich 1?
    ;   * Wenn NEIN (0): Die Zahl wurde schon mal gestrichen. Überspringe sie und gehe zum nächsten p.
    ;   * Wenn JA (1): Wir haben eine Primzahl gefunden!  Nun müssen wir ihre Vielfachen streichen.
    ;
    ; - INNERE SCHLEIFE (Das Streichen):
    ;   * Startwert: Setze das Vielfache i = p * p (Optimierung aus der Aufgabe).
    ;   * Bedingung: Solange i <= 1000 ist.
    ;   * Aktion: Schreibe eine 0 in das siebArray an der Stelle i (Zahl i ist somit gestrichen).
    ;   * Schritt: Erhöhe i um den Wert p (i = i + p), um das nächste Vielfache zu erreichen.
    ;   * Wiederhole die innere Schleife.

; --- 5. TEILFUNKTION: ABSPEICHERN DER ERGEBNISSE (saveResults) ---
; Analyse des fertigen Siebs und Extraktion der Zahlen:
    ; - Setze den Ergebnis-Zähler (r5) auf 0.
    ; - Schleife läuft erneut von Index 2 bis Index 1000.
    ; - Lade das Byte aus siebArray an der aktuellen Position.
    ; - Wenn das Byte 1 ist:
    ;   * Der aktuelle Index IST eine Primzahl.
    ;   * Schreibe den Wert des aktuellen Index in das primzahlenArray an der Stelle des Ergebnis-Zählers.
    ;   * Erhöhe den Ergebnis-Zähler um 1, damit die nächste Zahl einen Platz weiter hinten landet.
    ; - Wenn das Byte 0 ist: Tue nichts.
    ; - Wenn das Limit 1000 erreicht ist, springe in die Endlosschleife.

forever	b	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END
