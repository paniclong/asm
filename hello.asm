; db - 1 byte
; dw - 2 byte
; dd - 4 byte (int or float)
; dq - 8 byte (only for float)
; dt - 10 byte (only for float)

SECTION .data
        oldHello:       db "Old hello", 10
        oldHelloLen:    equ $-oldHello

        hello:          db "Hello", 10
        helloLen:       equ $-hello

        oldBye:         db "Old bye", 10
        oldByeLen:      equ $-oldBye

        bye:            db "Bye", 10
        byeLen:         equ $-bye

        choiceText:     db "Please, enter exit symbol (syscall - Y, 0x80 interrupt - N)", 10
        choiceTextLen:  equ $-choiceText


SECTION .bss
        buffer:     resb 1024
        number:     resb 1

SECTION .text
        global _start

; Sys calls number i386 x32 (0x80 interrupt)
; 1 - exit
; 2 - fork
; 3 - read
; 4 - write
; 5 - open
;
; Sys calls number i386 x64 (syscall)
; 0 - read
; 1 - write
; 2 - open
; 3 - close
; 60 - exit

_start:
        mov rax, 1 ; syscall number (write)
        mov rdi, 1 ; write to stdout
        mov rsi, hello
        mov rdx, 1
        syscall ; execute

        jmp enter_symbol

enter_symbol:
        mov rax, 1 ; syscall number (write)
        mov rdi, 1 ; write to stdout
        mov rsi, choiceText
        mov rdx, choiceTextLen
        syscall ; execute

        mov rax, 0 ; syscall number (read)
        mov rdi, 0 ; write to stdin
        mov rsi, number ; address of the buffer
        mov rdx, 1024 ; size of the buffer
        syscall ; execute

        mov eax, [number] ; Get first byte to register
        cmp eax, "Y" ; Compare, if equals set flag ZF = 1, else ZF = 0
        je  syscall_exit

        cmp eax, "N"
        je  exit

        mov eax, 0

        ; Else symbol not "Y" OR "N", enter again
        jmp enter_symbol

; Using 0x80 interrupt
exit:
        mov eax, 4
        mov ebx, 1
        mov ecx, oldBye
        mov edx, oldByeLen
        int 0x80

        mov eax, 1
        mov ebx, 0
        int 0x80

; Using syscall
syscall_exit:
        mov rax, 1 ; syscall number (write)
        mov rdi, 1 ; write to stdout
        mov rsi, bye
        mov rdx, byeLen
        syscall ; execute

        mov rax, 60 ; syscall number (exit)
        mov rdi, 0 ; error code
        syscall ; execute
