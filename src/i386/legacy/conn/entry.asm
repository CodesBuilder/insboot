%include "i386/mm.inc"

%define ERR_DETECTING_MMAP_MSG "Error detecting memory layout map"
%strlen ERR_DETECTING_MMAP_MSG_LEN ERR_DETECTING_MMAP_MSG

[BITS 16]
org 0x10000

cli

; E820 memory map detection
e820mmap_detect:
    ; Base address
    mov ax, SEG_R(0x30000)
    mov es, ax
    xor di, di

    clc ; Unset clear flag (indicates errors occurred)
    xor ebx, ebx ; Continuation

    .loop:
        mov eax, 0xe820 ; Function ID
        mov ecx, 20
        mov edx, 0x534d4150 ; 'SMAP'

        int 0x15
        add di, 20
        jnc .loop ; Jump if no errors occurred
        test ebx, ebx
        jz e820mmap_detect_end

        push errDetectingMmapMsg
        push ERR_DETECTING_MMAP_MSG_LEN
        call msgOut
        hlt

e820mmap_detect_end:

errDetectingMmapMsg dd ERR_DETECTING_MMAP_MSG

;
; Output a message.
;
; Parameters (stdcall):
; off:u16 - Offset of the string in data segment
; len:u16 - Length of the string
;
msgOut:
    push es
    pusha

    ; Segment index of the string
    mov ax,ds
    mov es,ax

    ; Offset in segment of the string
    pop bp
    pop cx

    mov ax,0x1301; Subroutine & mode
    mov bx,0x0002; Color of characters

    int 0x13; Call display ISR

    popa
    pop es
    retn
