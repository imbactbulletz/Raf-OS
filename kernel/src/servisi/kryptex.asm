


;-----------------------------
; Enkriptuje niz podataka:
; Ulaz: BX - adresa niza koji se enkriptuje
;       CX - duzina niza
; Izlaz : Nema. Modifikuje se postojeci niz.
;-----------------------------
_encrypt_data:
  pusha

  dec cx ; da ne bismo i LF karakter enkriptovali
  enc_loop:
  xor ax, ax
  mov al, [bx]
  call _encrypt_byte
  mov [bx], al
  inc bx
  ; call _int_to_string
  ; mov si, ax
  ; call _print_string
  ; call _print_newline
  loop enc_loop

  mov [bx], byte  10 ; dodajemo linefeed na kraju
  popa
  ret
;-----------------------------





;-----------------------------
; Enkriptuje jedan bajt
; Ulaz: AL
; Izlaz: AL
_encrypt_byte:
    pusha

    xor bx, bx ; setujemo bx na nula
    xor dx, dx ; setujemo dx na nula

    ; mov cx, ax
    ; call _int_to_string
    ; mov si, ax
    ; call _print_string
    ; call _print_newline
    ; mov ax, cx

    sub ax, 97 ; da budemo u opsegu [0,25]

    mov bl, al ; 'S' ; pomeramo S slovo u bl
    mov al, [a_key] ; pomeramo kljuc A u al
    mul bl ; mnozimo, rezultat je u ax

    mov dl, [b_key]
    add ax, dx


    mov bl, 26
    div bl



    xor bx, bx
    mov bl, ah
    mov ax, bx
    mov [temp_ax_val], ax
    call _int_to_string
    mov si, ax
    call _print_string
    call _print_newline
    popa
    mov ax, [temp_ax_val]
ret

  temp_ax_val dw 0
;-----------------------------







;-----------------------------
; Dekriptuje niz podataka:
; Ulaz BX - adresa niza koji se dekriptuje
;      CX - duzina niza
; Izlaz: Nema. Modifikuje se postojeci niz
;-----------------------------
_decrypt_data:
  pusha

  ;; dummy data
  ; mov bx, dummy_data
  ; mov cx, 6

  dec cx ; da ne bismo i LF karakter dekriptovali

  dec_loop:
  xor ax, ax ; isprazni ax
  mov al, [bx] ; ucita enkriptovani karakter

  call _decrypt_byte
  mov [bx], al ; upisuje dekriptovani karakter na mesto ekriptovanog
  inc bx ; prelazi na sledeci karakter

  ; call _int_to_string
  ; mov si, ax
  ; call _print_string
  ; call _print_newline

  loop dec_loop

  mov [bx], byte 10

  popa

  ret

;-----------------------------
; Dekriptuje jedan bajt
; Ulaz: AL
; Izlaz: AL
_decrypt_byte:
    pusha
    xor bx, bx
    xor dx, dx

    ; mov cx, ax
    ; call _int_to_string
    ; mov si, ax
    ; call _print_string
    ; call _print_newline
    ; mov ax, cx

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
    add ax, 97

    mov [temp_val], ax
    call _int_to_string
    mov si, ax
    call _print_string
    call _print_newline
    popa
    mov ax, [temp_val]
    ret


    temp_val dw 0


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
