; define gdt
gdt_start dq 0x0

gdt_code:
	dw 0xffff 		; segment length, bits 0-15
	dw 0x0 			; base address, bits 0-15
	db 0x0 			; segment base 16-23
	db 10011010b 	; flags (1 byte)
	db 11001111b	; flags (4 bits) + segment length, bits 16-19
	db 0x0 			; segment base, bits 24-31


gdt_data:
	dw 0xffff 		; segment length, bits 0-15
	dw 0x0 			; base address, bits 0-15
	db 0x0 			; segment base 16-23
	db 10010010b	; flags (1 byte)
	db 11001111b	; flags (4 bits) + segment length, bits 16-19
	db 0x0 			; segment base, bits 24-31

gdt_descriptor:
	dw $-gdt_start - 1 ; -1 cuz 16bit
	dd gdt_start

; gdt offsets for later use
CODE_SEG equ gdt_code - gdt_start 
DATA_SEG equ gdt_data - gdt_start

[bits 16]
protected_enter:
	cli 	; disable interrupts
	lgdt [gdt_descriptor]

	; set protection bit in psw
	mov eax, cr0
	or al, 1
	mov cr0, eax

	jmp CODE_SEG:protected_init

[bits 32]
protected_init:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000 ; stack at the top of free space
	mov esp, ebp

	call BEGIN_PM

