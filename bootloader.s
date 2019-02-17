[BITS 16]
[org 0x7c00]
	; Init stack
	mov bx, 0x8000
	mov bp, bx
	mov sp, bp

	; Print stuff
	lea bx, [hello]
	call print
	call print_ln

	mov dx, 0xdead
	call print_hex16
	call print_ln

	; Disk stuff
	mov bx, 0x8000

	mov dh, 2 ; read 2 sectors
	mov dl, 0x80 ; hdd 0
	call disk_load
	
	; Print from loaded memory
	mov dx, [0x8000]
	call print_hex16

	mov dx, [0x8000 + 512]
	call print_hex16
	call print_ln

	call protected_enter

	jmp $

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call gm_print
	jmp $


%include "io.s"
%include "disk.s"
%include "switch.s"

hello db "Shalom Olam",0
MSG_PROT_MODE db "Promode!!",0

; Magic value
times 510 - ($-$$) db 0
dw 0xaa55

; boot sector = sector 1 of cyl 0 of head 0 of hdd 0
; from now on = sector 2 ...
times 256 dw 0xcafe
times 256 dw 0xbabe
