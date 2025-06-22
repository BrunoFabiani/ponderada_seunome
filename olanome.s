org 0x0

jmp start

times 33 db 0

nome: 
    db "Digite seu nome: ", 0

msg_final:
    db "Ola ", 0       
    times 80 db 0      

buffer:
    db 20          
    db 0           
    db 20 dup(0)   

datena:
    mov ah, 0x0E    
    int 0x10    
    ret 

fausto_silva:
    lodsb
    cmp al, 0
    jz .done
    call datena
    jmp fausto_silva
.done:
    ret   

get_input:
    mov si, buffer + 2       
    mov cx, 20               
    mov byte [buffer+1], 0   

.next_char:
    mov ah, 0
    int 16h                  
    cmp al, 0x0D             
    je .done_input
    mov ah, 0x0E             
    mov bh, 0
    mov bl, 7               
    int 0x10

    mov [si], al             
    inc si
    inc byte [buffer+1]      
    loop .next_char

.done_input:
    mov byte [si], 0        
    ret

ola_usuario:
    mov si, msg_final

.find_end:
    cmp byte [si], 0
    je .append
    inc si
    jmp .find_end

.append:
    mov di, si             
    mov si, buffer + 2      

.copy_loop:
    lodsb                  
    cmp al, 0
    je .done_copy
    stosb                   
    jmp .copy_loop

.done_copy:
    mov byte [di], 0        
    ret



start:
    cli
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax

    mov ax, 0x0000
    mov ss, ax
    mov sp, 0x7c00

    sti

    mov si, nome
    call fausto_silva
    
    call get_input
    call ola_usuario

    ; Print newline
    mov ah, 0x0E
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10

    ; Print user input
    mov si, msg_final
    call fausto_silva

    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
