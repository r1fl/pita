; load 'dh' sectors from drive 'dl' into ES:BX
disk_load:
	pusha
	push dx

	mov ah, 0x02 	; int 0x13,0x2
	mov al, dh 		; number of sectors to read
	mov cl, 0x02 	; sector number

	mov ch, 0x00 	; cylinder number
	mov dh, 0x00 	; head number

	int 0x13
	jc .disk_error 	; error in carry

	pop dx
	cmp al, dh 		; BIOS sets 'al' to the # of sectors read.
	jne .sectors_error

	popa
	ret

	.disk_error:
		lea bx, [.DISK_ERROR]
		call print_error

		movzx dx, ah ; ah = error code, dl = disk drive that dropped the error
		call print_hex16

		jmp .disk_loop

	.sectors_error:
		mov bx, .SECTORS_ERROR
		call print_error

	; ??? retry disk read
	.disk_loop:
		jmp $


	.DISK_ERROR		db "Disk read error: ", 0
	.SECTORS_ERROR 	db "Incorrect number of sectors read", 0
