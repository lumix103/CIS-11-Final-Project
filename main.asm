.ORIG	x3000
    ; TODO: Start
    HALT

    GET_USER_INPUT
        JSR SAVE_REG            ; Need to save R7
        AND R1, R1, #0          ; Store result in R1
        GUI_LOOP
            AND R2, R2, #0      ; Temp storage
            GETC                ; Get Character
            ADD R2, R0, #-10    ; If R0 == 10 then break
            BRz BREAK_GUI_LOOP  ; ----------------------
            OUT                 ; Output character
            AND R2, R2, #0      ; Reinitialize R2
            ADD R2, R2, R0      ; R2 = R0
            ADD R2, R2, #-16    ; ASCII Offset
            ADD R2, R2, #-16    ; ------------
            ADD R2, R2, #-16    ; ------------
            BRn PANIC           ; Error not an ASCII value of 48 or higher
            ADD R2, R2, #-9     ; Checking if ascii value is higher than 47
            BRp PANIC           ; Error not an ASCII value of 57 or lower
            ADD R2, R2, #9      ; Peserving ACII value
            LD R3, MULT_X       ; Load x3101
            LD R4, MULT_Y       ; Load x3102
            AND R5, R5, #0      ; Clear R5
            ADD R5, R5, xA      ; R5 = 10
            STR R2, R3, #0      ; Store value of R2 at address hold by R3
            STR R5, R4, #0      ; Store value of R5 at address hold by R4
            JSR SAVE_REG        ; Save registers
            JSR MULT            ; Jump to subroutine MULT
            JSR LOAD_REG        ; Load registers
            LD R3, MULT_R       ; Load x3103
            LDR R3, R3, #0      ; Load value from address hold by R3 to R3
        BREAK_GUI_LOOP
        LD R2, PARSED_RESULT    ; Store result at x3100
        STR R1, R2, #0          ; ---------------------
        JSR LOAD_REG            ; Load registers
    RET
    MULT                        ; Positive integers only
        LD R0, MULT_X           ; Load x3101
        LD R1, MULT_Y           ; Load x3102
        LDR R0, R0, #0          ; Load value from address hold by R0 to R0
        LDR R1, R1, #0          ; Load value from address hold by R1 to R1
        AND R2, R2, #0          ; Clear R2 and use as results
        MULT_LOOP
            ADD R1, R1, #0      ; If R1 == 0 then break
            BRz BREAK_MULT_LOOP ; ---------------------
            ADD R2, R2, R1      ; R2 = R2 + R1
            ADD R1, R1, #-1     ; R1--
        BREAK_MULT_LOOP
        LD R0, MULT_R           ; Load value x3103
        STR R2, R0, #0          ; Store the value of R2 into the address hold by R0
    RET
    SAVE_REG
        ST R7, TEMP_SAVE
        LD R7, STACK_TOP
        STR R0, R7, #0
        STR R1, R7, #1
        STR R2, R7, #2
        STR R3, R7, #3
        STR R4, R7, #4
        STR R5, R7, #5
        STR R6, R7, #6
        ADD R7, R7, #7
        LD R0, TEMP_SAVE
        STR R0, R7, #0
        ADD R7, R7, #1
        ST R7, STACK_TOP
        LD R7, TEMP_SAVE
    RET
    LOAD_REG
        ST R7, TEMP_SAVE        ; Store the current value of R7 as a temp
        LD R7, STACK_TOP        ; Load the value at the top of the stack
        LD R0, EMPTY            ; Load the empty sentinel value 
        NOT R0, R0              ; Two's Complement
        ADD R0, R0, #1          ; ----------------
        LDR R1, R7 #0           ; Load the Value at the address hold by R7 in R1
        ADD R1, R1, R0          ; Add R1 and R0 together
        BRz LR_BREAK            ; If the value is zero skip
        LDR R0, R7, #-8         ; Load the value from address hold by R7 with an offset of -8 at R0
        LDR R1, R7, #-7         ; Load the value from address hold by R7 with an offset of -7 at R1
        LDR R2, R7, #-6         ; Load the value from address hold by R7 with an offset of -6 at R2
        LDR R3, R7, #-5         ; Load the value from address hold by R7 with an offset of -5 at R3
        LDR R4, R7, #-4         ; Load the value from address hold by R7 with an offset of -4 at R4
        LDR R5, R7, #-3         ; Load the value from address hold by R7 with an offset of -3 at R5
        LDR R6, R7, #-2         ; Load the value from address hold by R7 with an offset of -2 at R6

        LD R1, EMPTY            ; Load the value of empty sentinel
        STR R1, R7, #-1         ; Store the empty sentinel at the address hold by R7 with an offset of -1

        LDR R1, R7, #-7         ; Load the value from address hold by R7 with an offset of -7 at R7
        ADD R7, R7, #-8 
        ST R7, STACK_TOP
        LR_BREAK  
        LD R7, TEMP_SAVE
    RET
.END

PARSED_RESULT   .FILL	x3100

MULT_X          .FILL	x3101
MULT_Y          .FILL	x3102
MULT_R          .FILL	x3103

INT_ARR         .FILL	x3104

REG_TEMP        .FILL	x310C
REG_STACK       .FILL	x310D

EMPTY           .FILL	xC000

PROMPT          .STRINGZ	"Enter a number within 0 and 100: "