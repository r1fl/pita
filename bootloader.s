[BITS 16]
[org 0x0]
	; Init data
	mov ax, 0x7c0
	mov ds, ax

	; Init stack
	mov bx, 0x8000
	mov bp, bx
	mov sp, bp

	lea bx, [hello]
	call print
	call print_ln

	mov dx, 0xdead
	call print_hex16

	jmp $

%include "text.s"
hello db "Shalom Olam",0

; Magic value
times 510 - ($-$$) db 0
dw 0xaa55



