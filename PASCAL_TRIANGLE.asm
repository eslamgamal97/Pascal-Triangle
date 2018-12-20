;====================================================Assembly Language Project=============================================================
; Project: Pascal`s Triangle 
; 
;   Written by :                           
;       Ahmed Elsayed Mostafa Elsayed     12 
;       Eslam Gamal Elsayed Esmail        54
;        
; 
;==========================================================================================================================================


include 'emu8086.inc'      ;include emu8086 library to use Print Functions                             
ORG 100h                   ;this directive required for a simple 1 segment .com program.
LOOP0:
    LEA SI,msg             ;ask for the number
    CALL print_string 
    CALL scan_num          ;get number in CX
                                
;==========================================================================================================================================                                
       ;print new line
       MOV AH,2   ;Print a character 
       MOV DL,10  ;value of new line in ASCII CODE  
       INT 21H     
;==========================================================================================================================================
.code       
MAIN PROC    
CMP CX,0             ;check if number of rows is zero or not
JE LOOP4             ;if zero, jump to LOOP4 to try again
MOV SI,CX            ;number of rows
MOV DI,0000          ;row number
MOV BP,0000          ;column number
DEC BP               ;DEC BP to INC it in loop 
 
;========================================================================================================================================== 
; LOOP1 used for calculating Pascal Numbers
LOOP1:    
    INC BP                     ; set BP to current column number

    MOV AX,DI                  ; set AX to current row number to calculate its factorial
    CALL factorial_calc
    MOV DS,AX                  ;N!
    

    MOV AX,BP                  ; set AX to current column number to calculate its factorial
    CALL factorial_calc
    MOV ES,AX                  ;K!
    
    MOV AX,DI
    SUB AX,BP                  ; calculate n-k
    CALL factorial_calc        ;calculate (n-k)!
    
    MOV CX,ES 
    MUL CX                     ;K! N-K!  
    
    MOV CX,AX
    MOV AX,DS
    DIV CX                     ;Calculate n!/((k!)*(n-k)!)
    CALL PRINT_NUM             ;Print the Pascal Number
    MOV AH,2H 
    MOV DX,20H                 ;print a space
    INT 21H                    ;to print a character
    CMP DI,BP                  ;if column number eguals row number so it must move to next row
    JNZ LOOP1                  ;if not so it should repeat calculation in current row 
    JMP LOOP2      
    

;==========================================================================================================================================     
; LOOP2 used for creating new line after each row and increase current row number    
LOOP2:
    MOV AH,2H
    MOV DX,0AH     ;print new line
    INT 21H
    MOV DX,13      ;print carriage return
    INT 21H  
    MOV BP,0000    ;set column number to 0 
    DEC BP
    INC DI   
    CMP SI,DI      ;if current row number equals row number, it will stop executing
    JE LOOP3    
    JMP LOOP1      ;if not, jump to loop1 and repeat

;LOOP3 to stop executing program    
LOOP3:
    HLT       

;LOOP4 to allow user to try again if he enteres zera as a number of rows    
LOOP4:
    PRINT 'NUMBER OF ROWS MUST BE GREATER THAN ZERO, PLEASE TRY AGAIN'
    MOV AH,2H
    MOV DX,0AH     ;print new line
    INT 21H
    MOV DX,13      ;print carriage return
    INT 21H 
    PRINT '----------------------------------------------------------'
    MOV DX,0AH     ;print new line
    INT 21H
    MOV DX,13      ;print carriage return
    INT 21H          
    JMP LOOP0

 MAIN ENDP    


;==========================================================================================================================================             
msg DB 'Enter number of rows: ',0    ;this string is zero terminated

;Define functions
DEFINE_SCAN_NUM                      ;to get number as a input from user
DEFINE_PRINT_NUM                     ;to print a number
DEFINE_PRINT_NUM_UNS                 ;required for PRINT_NUM
DEFINE_PRINT_STRING                  ;to print string
                      

;procedure as a factorial function (calculation)
factorial_calc proc  
    MOV CX,AX
    MOV AX,1
    CMP CX,0
    JE RETURN
    FAC:
    MUL CX
    CMP CX,01                        ;loop FAC until CX does not equal to 1 
    LOOPNE FAC
    RETURN:
    RET
    factorial_calc ENDP        

end                                  ; directive to stop the compiler    