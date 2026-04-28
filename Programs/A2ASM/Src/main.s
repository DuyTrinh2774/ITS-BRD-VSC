;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke    
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main to demonstrate data transfer
;                     : and manipulation.
;                     : 
;
;*******************************************************************************
    EXTERN initITSboard ; Helper to organize the setup of the board

    EXPORT main         ; we need this for the linker - In this context it set the entry point,too

ConstByteA  EQU 0xaffe
    
;* We need some data to work on
    AREA DATA, DATA, align=2    
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0x0000

;* We need minimal memory setup of InRootSection placed in Code Section 
    AREA  |.text|, CODE, READONLY, ALIGN = 3    
    ALIGN   
main
    BL initITSboard             ; needed by the board to setup
;* swap memory - Is there another, at least optimized approach?
    ldr     R0,=VariableA   ; Anw01
    ldrb    R2,[R0]         ; Anw02
    ldrb    R3,[R0,#1]      ; Anw03
    lsl     R2, #8          ; Anw04
    orr     R2, R3          ; Anw05
    strh    R2,[R0]         ; Anw06 
    
;* const in var
    mov     R5,#ConstByteA  ; Anw07
    strh    R5,[R0]         ; Anw08

;* Eigene Erweiterung für VariableC
    ldr     R0, =VariableC  ; Lade die Adresse der neuen VariableC in R0
    mov     R2, #0xAF       ; Lade das "hochwertige" Byte AF in R2
    strb    R2, [R0]        ; Speichere AF an die erste Adresse (links)
    mov     R3, #0xFE       ; Lade das "niederwertige" Byte FE in R3
    strb    R3, [R0, #1]    ; Speichere FE an die Adresse + 1 (rechts daneben)    

;* Change value from x1234 to x4321
    ldr     R1,=VariableB   ; Anw09
    ldrh    R6,[R1]         ; Anw0A
    ;mov     R7, #0x30ED     ; Anw0B
    ;add     R6, R6, R7      ; Anw0C

    lsl     R2, R6, #8      ; Schiebt 0x34 in den oberen Teil -> R2 = 0x3400 [4]
    lsr     R3, R6, #8      ; Schiebt 0x12 in den unteren Teil -> R3 = 0x0012 [4]
    orr     R6, R2, R3      ; Kombiniert beide Teile -> R6 = 0x3412 [5]

    strh    R6,[R1]         ; Anw0D
    b .                     ; Anw0E
    
    ALIGN
    END