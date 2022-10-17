default rel

%include "macros.mac"

global _start

%define END_OF_STRING 0x24
%define BYTE_SIZE_64 8

SECTION .data
    first_arr:      dq  1, 2, 3, 4, 5, 6, END_OF_STRING
    second_arr:     dq  7, 8, 9, 10, 11, 12, 1, END_OF_STRING
    value1:         dd  0x60

    error_msg:      dq "Length of arrays not equals", 0xA
    error_msg_len:  equ $-error_msg

    float1:         dd 3.25
    float2:         dd 1.0
    test:           db 1
SECTION .bss
    sum             resq    7
    print_value     resq    1

SECTION .text
_start:
    array_length first_arr, END_OF_STRING, BYTE_SIZE_64

    push rcx

    array_length second_arr, END_OF_STRING, BYTE_SIZE_64

    pop rdx

    cmp rdx, rcx
    je sum_elements

    jmp .error

.error:
    mov rax, 1          ; syscall number (write)
    mov rdi, 1          ; write to stdout
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall

    mov rax, 60 ; syscall number (exit)
    mov rdi, 0  ; error code
    syscall     ; execute
sum_elements:
    xor rcx, rcx
    mov rdx, END_OF_STRING
.loop:
    mov r8, 0

    add r8, [first_arr+rcx*8]

    cmp rdx, r8
    je quit

    add r8, [second_arr+rcx*8]

    mov [sum+rcx*8], r8

    inc rcx

    jmp .loop

quit:
    xor r8, r8
    mov r9, [value1]          ; Load address (value1) to register
.loop:
    cmp r8, 5              ; Compare (10 iteration)
    je .quit1

    mov [print_value], r9           ; Move value (address value1) to r10 register
    ; add     qword [print_value], "0"    ; Convert first value to ASCII character

    mov     rax, 1          ; syscall number (write)
    mov     rdi, 1          ; write to stdout
    mov     rsi, print_value
    mov     rdx, 1
    syscall

    inc r8
    dec r9

    jmp .loop

.quit1:
    mov rax, 60 ; syscall number (exit)
    mov rdi, 0  ; error code
    syscall     ; execute
