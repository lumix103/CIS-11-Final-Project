.ORIG	x3000
    JSR PROMPT_USER_INPUT
    JSR BUBBLE_SORT
    HALT
    PANIC 
        HALT
    PROMPT_USER_INPUT
        ST R7, TEMP1
        JSR SAVE_REG
        AND R1, R1, #0          ; Counter
        PUI_LOOP
            AND R2, R2, #0
            ADD R2, R2, #-8
            ADD R2, R1, R2
            BRz BREAK_PUI_LOOP
            LEA R0, PROMPT
            PUTS
            JSR SAVE_REG
            JSR GET_USER_INPUT
            JSR LOAD_REG
            LD R0, INT_ARR
            ADD R0, R0, R1
            LD R2, PARSED_RESULT
            LDR R2, R2, #0
            STR R2, R0, #0
            ADD R1, R1, #1
            BR PUI_LOOP
        BREAK_PUI_LOOP
        JSR LOAD_REG
        LD R7, TEMP1
    RET
    GET_USER_INPUT
        ST R7, TEMP
        JSR SAVE_REG
        AND R1, R1, #0          ; Store result in R1
        GUI_LOOP
            AND R2, R2, #0      ; Temp storage
            GETC                ; Get Character w/ echo
            OUT                 ; ----------------------
            ADD R2, R0, #-10    ; If R0 == 10 then break
            BRz BREAK_GUI_LOOP  ; ----------------------
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
            STR R1, R3, #0      ; Store value of R1 at address hold by R3
            STR R5, R4, #0      ; Store value of R5 at address hold by R4
            JSR SAVE_REG        ; Save registers
            JSR MULT            ; Jump to subroutine MULT
            JSR LOAD_REG        ; Load registers
            LD R3, MULT_R       ; Load x3103
            LDR R3, R3, #0      ; Load value from address hold by R3 to R3
            ADD R1, R3, R2      ; R1 = R3 + R2 => R1 = 10 * R1 + R2
            BR GUI_LOOP
        BREAK_GUI_LOOP
        LD R2, PARSED_RESULT    ; Store result at x3100
        STR R1, R2, #0          ; ---------------------
        JSR LOAD_REG            ; Load registers
        LD R7, TEMP
    RET
    MULT
        LD R0, MULT_X
        LDR R0, R0, #0
        LD R1, MULT_Y   ; Counter
        LDR R1, R1, #0
        AND R2, R2, #0  ; Result 
        MULT_LOOP
            ADD R1, R1, #0
            BRnz MULT_BREAK
            ADD R2, R2, R0
            ADD R1, R1, #-1
            BR MULT_LOOP
        MULT_BREAK
        LD R0, MULT_R
        STR R2, R0, #0
    RET
    SAVE_REG
        ST R7, REG_TEMP
        LD R7, REG_STACK
        STR R0, R7, #0
        STR R1, R7, #1
        STR R2, R7, #2
        STR R3, R7, #3
        STR R4, R7, #4
        STR R5, R7, #5
        STR R6, R7, #6
        ADD R7, R7, #7
        LD R0, REG_TEMP
        STR R0, R7, #0
        ADD R7, R7, #1
        ST R7, REG_STACK
        LD R7, REG_TEMP
    RET
    LOAD_REG
        ST R7, REG_TEMP         ; Store the current value of R7 as a temp
        LD R7, REG_STACK        ; Load the value at the top of the stack
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
        ST R7, REG_STACK
        LR_BREAK  
        LD R7, REG_TEMP
    RET
    BUBBLE_SORT
        ST R7, TEMP                         ; Save R7 into TEMP
        JSR SAVE_REG                        ; Save Registers
        AND R1, R1, #0                      ; Inintialize counter 1
        BSO_LOOP                            
            AND R3, R3, #0                  ; Clear R3 
            ADD R3, R3, #-7                 ; R3 = -7
            AND R4, R4, #0                  ; Clear R4
            ADD R4, R3, R1                  ; if counter1 < 7 then continue
            BRzp BREAK_BSO_LOOP             ; else break
                AND R2, R2, #0              ; Inintialize counter 2
                BSI_LOOP
                    AND R4, R4, #0          ; Clear R4
                    ADD R4, R4, R1          ; R4 = R1
                    NOT R4, R4              ; Two's complement of R4 (-R4)
                    ADD R4, R4, #1          ; ----------------
                    ADD R4, R4, #7          ; R4 = counter1 - 8
                    NOT R4, R4              ; Two's complement
                    ADD R4, R4, #1          ; ----------------
                    ADD R4, R2, R4          ; counter2 - (counter1 - 7 - 1) < 0 or counter2 - counter1 + 8 < 0
                    BRzp BREAK_BSI_LOOP
                    LD R0, INT_ARR          ; Load value x3104
                    ADD R0, R0, R2          ; x3104 + counter2
                    LD R3, INT_ARR          ; Load value x3104
                    ADD R3, R3, R2          ; x3014 + counter2 + 1
                    ADD R3, R3, #1          ; --------------------
                    LDR R4, R0, #0          ; Load the value from address hold by R0 into R4 
                    LDR R5, R3, #0          ; Load the value from address hold by R3 into R5
                    AND R6, R6, #0          ; Clear R6
                    ADD R6, R6, R5          ; R6 = R5
                    NOT R6, R6              ; Two's Complement
                    ADD R6, R6, #1          ; ----------------
                    ADD R6, R4, R6          ; INT_ARRAY[COUNTER1] - INT_ARRAY[COUNTER2]
                    BRnz BSI_GREATER_FALSE
                        STR R4, R3, #0      ; Store the value of R4 into the address hold by R3
                        STR R5, R0, #0      ; Store the value of R5 into the address hold by R0
                    BSI_GREATER_FALSE  
                    ADD R2, R2, #1          ; Increment counter2
                    BR BSI_LOOP
                BREAK_BSI_LOOP
            ADD R1, R1, #1                  ; Increment coutnter1
            BR BSO_LOOP                     
        BREAK_BSO_LOOP
        JSR LOAD_REG                        ; Load Registers
        LD R7, TEMP                         ; Load R7 into TEMP
    RET
    DIV
        LDI R0, DIV_X   ; x
        LDI R1, DIV_Y   ; y
        AND R5, R5, #0  ; Clear R5 > counter
        AND R6, R6, #0  ; Clear R6 > sign
        ADD R0, R0, #0
        BRn ISXNEG      ; if x < 0 then x = -x
        CHECKYNEG
        ADD R1, R1, #0
        BRn ISYNEG
        BR ISNOTNEG     ; if y < 0 then y = -x
        ISXNEG
            NOT R0, R0
            ADD R0, R0, #1
            NOT R6, R6
            ADD R6, R6, #1
            BR CHECKYNEG
        ISYNEG
            NOT R1, R1
            ADD R1, R1, #1
            NOT R6, R6
            ADD R6, R6, #1
            BR ISNOTNEG
        ISNOTNEG
        NOT R1, R1      ; y = -y
        ADD R1, R1, #1  ; ------
        DIVLOOP
            ADD R0, R0, R1  ;   then  x = x - y
            BRn ISNEG       ;         if x <= 0
            ADD R5, R5, #1  ;            counter++
            BRz ISZERO      ;           then  break
            BR DIVLOOP
        ENDDIVLOOP
        ADD R0, R0, #0      ; LC3 Does not like two labels next to each other so
        ISNEG               ; Add back R1 because R0 is the remainder
            NOT R1, R1
            ADD R1, R1, #1
            ADD R0, R0, R1
        ISZERO
            ADD R6, R6, #0
            BRnz SIGNOTNEG
            NOT R0, R0      ; x = -x
            ADD R0, R0, #1  ; ------
            NOT R5, R5      ; counter = -counter
            ADD R5, R5, #1  ; ------------------
            SIGNOTNEG
            STI R5, DIV_R
            STI R0, DIV_REM
    RET
    DIV_X           .FILL   x3200
    DIV_Y           .FILL	x3201
    DIV_R           .FILL	x3202
    DIV_REM         .FILL	x3203
    PARSED_RESULT   .FILL	x3100
    MULT_X          .FILL	x3101
    MULT_Y          .FILL	x3102
    MULT_R          .FILL	x3103
    INT_ARR         .FILL	x3104   
    REG_TEMP        .FILL	x310C
    REG_STACK       .FILL	x310D
    EMPTY           .FILL	xC000
    TEMP            .FILL	x0
    TEMP1           .FILL	x0
    PROMPT          .STRINGZ	"Enter a number within 0 and 100: "
.END