


;-----------------------------
; Enkriptuje niz podataka:
; Ulaz: CX - adresa niza koji se enkriptuje
;       BX - duzina niza
; Izlaz : Nema. Modifikuje se postojeci niz.
_encrypt_data:
    pusha

    xor ax, ax ; setujemo ax na nula
    xor bx, bx ; setujemo bx na nula
    xor dx, dx ; setujemo dx na nula

    mov al, [a_key] ; pomeramo kljuc A u al
    mov bl, 83 ; 'S' ; pomeramo S slovo u bl
    mul bl ; mnozimo, rezultat je u ax

    mov dl, [b_key]
    add ax, dx

    mov bl, 26
    div bl

    xor bx, bx
    mov bl, ah
    mov ax, bx

    call _int_to_string
    mov si, ax
    call _print_string

    popa
ret
;-----------------------------







;-----------------------------
; Dekriptuje niz podataka:
; Ulaz CX - adresa niza koji se dekriptuje
;      BX - duzina niza
; Izlaz: Nema. Modifikuje se postojeci niz
_decrypt_data:
    pusha
    xor ax, ax
    xor bx, bx
    xor dx, dx
    mov al, 21 ; c

    mov bl, [b_key]; ; b kljuc

    sub al, bl ; c - b

    mov dx, ax ; privremeno cuvamo ax sadrzaj

    mov ah, 0
    mov al, [a_key]
    call _inverse ; a^(-1)


    mov bl, al ; premestamo rezultat od inverse u bl
    mov al, dl ; vracamo ax sadrzaj

    mul bl

    mov bl, 26

    div bl

    xor bx, bx
    mov bl, ah
    mov ax, bx
    call _int_to_string
    mov si, ax
    call _print_string

    popa
    ret





;-----------------------------
; Input:  AL = Number to inverse in Z26
; Output: AL = Modular multiplicative inverse
; Output: CF is set if there is no inverse


_inverse:
		clc
		pushf
		push ax
		push si

		cmp al, 25
		ja .wrong_input


		xor ah, ah
		mov si, .translation_table
		add si, ax

		mov al, byte [si]
		or al, al
		jz .wrong_input

			; Good input
		mov byte [.tmp_al], al

		pop si
		pop ax
		popf

		mov al, byte [.tmp_al]
		clc
		ret


.wrong_input:
		pop si
		pop ax
		popf
		stc
		ret


	.translation_table: db 0, 1, 0, 9, 0, 21, 0, 15, 0, 3, 0, 19, 0, 0, 0, 7, 0, 23, 0, 11, 0, 5, 17, 0, 25
	.tmp_al db 0
;-----------------------------
