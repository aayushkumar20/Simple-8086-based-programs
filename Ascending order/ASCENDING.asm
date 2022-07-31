.MODEL small
.STACK 1000h                        
.DATA
    Struct0A EQU $                  
        max db 7                  
        got db 0                    
        buf db 100 dup (0)          
    Linefeed db 13, 10, '$'
    GetString   db '$'

.CODE
start:
    mov ax, @DATA                           
    mov ds, ax
    mov ah, 09h
    mov dx, OFFSET GetString
    int 21h
    mov dx, OFFSET Struct0A
    mov ah, 0Ah
    INT 21h

    mov si, OFFSET buf                       
    xor bx, bx                              
    mov bl, got                             
    mov BYTE PTR [si + bx], '$'             

    outer:
    dec bx                                  
    jz done                                 
    mov cx, bx                              
    mov si, OFFSET buf
    xor dl, dl                              

    inner:
    mov ax, [si]                            
    cmp al, ah                              
    jbe S1                                  
    mov dl, 1                               
    xchg al, ah                             
    mov [si], ax                            
    S1:
    inc si                                  
    loop inner

    test dl, dl                             
    jnz outer                               
    done:
    mov dx, OFFSET Linefeed
    mov ah, 09h
    int 21h
    mov dx, OFFSET buf
    mov ah, 09h
    int 21h

    mov ax, 4C00h
    int 21h

END start