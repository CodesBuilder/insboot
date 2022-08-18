%include "i386/mm.inc"

%define MISSING_BOOTDEV_MSG "No bootable device found"
%strlen MISSING_BOOTDEV_MSG_LEN MISSING_BOOTDEV_MSG

org 0x07c00

BITS 16

mov ax,cs
mov ds,ax

rstg2ldr:

    ; Load LBA 1-63 to 0x10000, and load the first sector onto 0x10000 - 512
    mov ax,SEG_R(0x10000 - 512)
    mov es,ax ; Segment index of 0x10000
    xor bx,bx ; Offset in segment is 0
    mov cx, 80 ; Loop for 80 times

    .loop:
        push cx ; Save CX for looping

        mov ax,0x30_02 ; AH = 0x30 AL = 0x02

        ; DL = 255 - CX + 1
        mov dl,255
        sub dl,cl
        inc dl

        xor cx,cx ; CH = 0, CL = 0
        xor dh,dh ; DH = 0

        int 0x13 ; Call disk reading ISR

        pop cx ; Restore CX for looping

        ; Check the disk signature
        mov eax,[es:440]; Copy the signature to EAX
        cmp eax,[ds:(0x7c00 + 440)]; Compare as signature data in sector the ISR read
        je rstg2ldr_success ; Break if the signature can be matched

        rep jmp .loop ; Go to loop head

        ; Segment index of the string
        mov ax,ds
        mov es,ax

        ; Offset in segment of the string
        mov ax, bootdevNotFoundMsg
        mov bp, ax

        mov cx,MISSING_BOOTDEV_MSG_LEN; Length of the string
        mov ax,0x1301; Subroutine & mode
        mov bx,0x0002; Color of characters

        int 0x13; Call display ISR

        ; Halt here
        cli
        hlt

    ; Jump to 0x10000
    rstg2ldr_success:
    mov ax,SEG_R(0x10000)
    mov ds,ax
    jmp [ds:0]

bootdevNotFoundMsg db MISSING_BOOTDEV_MSG

times 440-($-$$) db 0