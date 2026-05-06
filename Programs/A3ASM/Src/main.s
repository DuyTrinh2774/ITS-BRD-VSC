;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- S t a r t des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; HW Initialisieren

; Laden von Konstanten in Register

    ; Lädt den hexadezimalen Wert 0x12 (Dezimal 18) direkt in Register R0.
                mov   r0,#0x12                      ; Anw-01

    ; Lädt den negativen Wert -128 als Zweierkomplement in Register R1.
                mov   r1,#-128                      ; Anw-02

    ; Lädt eine 32-Bit Konstante 0x12345678 in R2. Da sie zu groß für MOV ist, wird sie aus dem Speicher geladen.
                ldr   r2,=0x12345678                ; Anw-03



; Zugriff auf Variable

    ; Lädt die Speicheradresse der Variable "VariableA" in das Register R0.
                ldr   r0,=VariableA                 ; Anw-04

    ; Lädt den 16-Bit-Inhalt (Halbwort) von der Adresse in R0 in das Register R1.
                ldrh  r1,[r0]                       ; Anw-05
                
    ; Lädt 32-Bit (Wort) ab der Adresse in R0 in R2 (liest VariableA und VariableB zusammen).
                ldr   r2,[r0]                       ; Anw-06

    ; Berechnet die Adresse von VariableC (Offset) und speichert den Wert aus R2 dort ab.
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07



; Zugriff auf Felder (Speicherzellen)
                
    ; Lädt die Startadresse von "MeinHalbwortFeld" in Register R0.                
                ldr   r0,=MeinHalbwortFeld          ; Anw-08

    ; Lädt das erste Element (Index 0, 16-Bit) in R1.             
                ldrh  r1,[r0]                       ; Anw-09
            
    ; Lädt das zweite Element (Index 1, 2 Bytes Offset) in R2.             
                ldrh  r2,[r0,#2]                    ; Anw-10

    ; Schreibt den Wert 10 (als Offset für 10 Bytes) in Register R3.            
                mov   r3,#10                        ; Anw-11

    ; Lädt das Element an der Adresse R0 + Offset R3 (Index 5) in R4.                
                ldrh  r4,[r0,r3]                    ; Anw-12


    ; Erhöht R0 erst um 2 (Pre-Index) und lädt dann das dortige Halbwort in R5.
                ldrh  r5,[r0,#2]!                   ; Anw-13

    ; Erhöht die aktuelle Adresse in R0 erneut um 2 und lädt das nächste Halbwort in R6.    
                ldrh  r6,[r0,#2]!                   ; Anw-14

    ; Erhöht R0 um 2 und überschreibt diesen Speicherplatz mit dem Wert aus R6.
                strh  r6,[r0,#2]!                   ; Anw-15



; Addition und Subtraktion von unsigned / signed Integer-Werten
                
    ; Lädt die Startadresse von "MeinWortFeld" (32-Bit Werte) in R0.               
                ldr  r0,=MeinWortFeld               ; Anw-16

    ; Lädt das erste Wort (4 Bytes) in R1.
                ldr  r1,[r0]                        ; Anw-17

    ; Lädt das zweite Wort (4 Bytes Offset) in R2.
                ldr  r2,[r0,#4]                     ; Anw-18
               
    ; Addiert R1 und R2, speichert Ergebnis in R3. Das "s" aktualisiert die Status-Flags (N,Z,C,V).
                adds r3,r1,r2                       ; Anw-19

    ; Lädt das dritte Wort (8 Bytes Offset) in R4.
                ldr  r4,[r0,#8]                     ; Anw-20
    
    ; Lädt das vierte Wort (12 Bytes Offset) in R5.
                ldr  r5,[r0,#12]                    ; Anw-21

    ; Subtrahiert R5 von R4, speichert Ergebnis in R6. Aktualisiert die Flags.
                subs r6,r4,r5                       ; Anw-22

    ; Lädt das fünfte Wort (16 Bytes Offset) in R7.
                ldr  r7,[r0,#16]                    ; Anw-23

    ; Lädt das sechste Wort (20 Bytes Offset) in R8.
                ldr  r8,[r0,#20]                    ; Anw-24

    ; Subtrahiert R8 von R7, speichert Ergebnis in R9. Aktualisiert die Flags.
                subs r9,r7,r8                       ; Anw-25


                ldr  r0,=MeinTextFeld               ;

    ; Endlosschleife, die das Programm am Ende anhält.           
forever         b   forever                         ; Anw-26
                ENDP
                END