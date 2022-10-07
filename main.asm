; 64 bit
; rbp - base pointer
; rsp - stack pointer

global _start

SECTION .data
        choice:     dw 'Y A', 0
        name:       dw  'A b c', 10
        lenName:    equ $-name
        name2:      dw  'B'
        array:      dq 1, 2, 3, 4, 5

SECTION .bss
        n resd 1
        f resd 1
        ;v resw 1

SECTION .text
        ; Macro section
        %macro push_bp 0
            push    rbp        ; Push old base pointer to stack
            mov     rbp, rsp   ; Move stack point to base pointer
        %endmacro

        %macro pop_bp 0
            mov     rsp, rbp   ; Move base pointer to stack pointer
            pop     rbp        ; Pop base pointer
        %endmacro

        %macro pop_sp 2
            add     rsp, (%1 * %2)  ; Offset
        %endmacro
        ; End macro section
_start:
        mov     [n], dword '300'
        mov     [f], dword '500'

        push    3
        push    n
        call    print
        add     rsp, 16

        ; mov eax, [name] -> move value of name variable to eax register
        ; mov eax, name -> move address of name variable to eax register
        ;
        ; mov [name], dword 0x30 -> move value in first byte
        ; mov name, 3 -> wrong, 'mov name, dword 3' -> correct
        ; mov eax, 3 -> correct
        ; mov     ebx, name
        ; mov     [ebx+4], dword 0x30
        ; add     ebx, 2
        ; mov     [ebx], dword 0x32
        ; mov     [name], ebx

        push    3
        push    f
        call    print

        pop_sp  2, 8

        push    5
        push    name
        call    print
        pop_sp  2, 8

        push    array
        call    each_array
        pop_sp  1, 8

        call    exit
print:
        push_bp

        mov     rax, 1          ; syscall number (write)
        mov     rdi, 1          ; write to stdout
        mov     rsi, [rbp+16]
        mov     rdx, [rbp+24]
        syscall

        pop_bp

        ret

each_array:
        push_bp

        mov     rcx, 5          ; Length of array
        mov     rdx, array      ; Move address of array to register
        mov     rax, [rdx]      ; Move first element to register
        mov     [n], rax        ; Move value to memory
        add     [n], dword "0"  ; Convert number to ASCII character

        push    1
        push    n
        call    print
        add     rsp, 16

        pop_bp

        ret

loop:


exit:
        mov     rax, 60         ; syscall number (exit)
        mov     rdi, 0          ; error code
        syscall                 ; execute

        ret
