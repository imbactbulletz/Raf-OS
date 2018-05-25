


;-----------------------------
; Enkriptuje niz podataka:
; Ulaz: CX - adresa niza koji se enkriptuje
;       BX - duzina niza
; Izlaz : Nema. Modifikuje se postojeci niz.
_encrypt_data:
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

ret
