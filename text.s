; Print a string pointed by 'bx'
print:
	pusha

	xor ax, ax
	mov ah, 0x0e

	.loop:
		mov al, [bx]
		test al, al
		jz .done

		int 0x10
		inc bx
		jmp .loop
	
	.done:
		popa
		ret

; Print an error message pointed by 'bx'
print_error:
	push bx

	lea bx, [.ERR_STRING]
	call print

	pop bx
	call print
	call print_ln

	ret

	.ERR_STRING db "[!] ",0

; Print line feed
print_ln:
	push ax

	mov ah, 0x0e
	mov al, 0x0d ; '\r'
	int 0x10

	mov al, 0x0a ; '\n'
	int 0x10

	pop ax
	ret


; Print hex value of 'dx'
print_hex16:
	; 0x30 <= ASCII NUMBERS <= 0x39
	; 0x41 <= ASCII LETTERS <= 0x46
	pusha

	xor cx, cx
	.hex_loop:
		cmp cx, 4 		; loop 4 times
		je .printbuf

		mov ax, dx
		and ax, 0x000f	; mask first three digits
		add al, 0x30	; numeric ascii

		cmp al, 0x39
		jle .insert

		add al, 7		; convert to char

	; insert character to HEX_BUF string
	.insert:
		lea bx, [.HEX_BUF + 5] 	; first digit
		sub bx, cx
		mov [bx], al 			; insert char

		inc cx
		shr dx, 4				; 0xdead => 0x0dea
		jmp .hex_loop

	.printbuf:
		lea bx, [.HEX_BUF]
		call print

		popa
		ret

	.HEX_BUF db '0x0000',0
