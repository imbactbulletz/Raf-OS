; ==========================================================================
; Univerzitet Union, Racunarski fakultet u Beogradu
; 08.2008. Operativni sistemi
; ==========================================================================
; RAF_OS -- Trivijalni skolski operativni sistem
; KERNEL
;
; Ucitava se direktno upotrebom programa sa boot sektora.
; Za kernel je predvidjena memorija velicine 6000h (24 KB).
; Odmah iza toga nalazi se bafer za disk operacije, velicine 2000h (8KB).
; Neposredno iza bafera (lokacija 8000h) ucitavaju se svi programi.
; ---------------------------------------------------------------------------
; Inicijalna verzija 0.0.1 (Stevan Milinkovic, 20.08.2010.)
; ---------------------------------------------------------------------------

    %define RAF_OS_VER ' ver. 0.1.2'        ; Verzija operativnog sistema
    %define RAF_OS_API_VER 1                ; API verzija (proveravaju je aplikacije)

     DiskBafer equ 6000h

    %include "vektor.inc"

_main:
        mov     ax, 0
        mov     ss, ax                      ; Segment koji koristi BIOS
        mov     sp, 0FFFFh                  ; Inicijalizacija stek pointera na vrh steka
        cld                                 ; Pravac operacija sa stringovima (ka rastucim adresama)

        mov     ax, cs                      ; Podesavanje svih segmenata na segment gde se ucitava kernel.
        mov     ds, ax                      ; Nakon ovoga, vise nema potrebe voditi racuna o segmentima
        mov     es, ax                      ; jer ce se sve (osim stek operacija) odvijati unutar nasih 64K.
        mov     fs, ax
        mov     gs, ax

        mov     ax, 1003h                   ; Sjajan tekst bez treptanja
        mov     bx, 0
        int     10h
        call    _seed_random                ; Seed za generator slucajnih brojeva


        ;--------------------------------------------
        ; parsira cipher.key
        pusha
        pushf
        push si

        mov ax, key_file_name
        mov cx, 9000h
        call _load_file; cita sadrzaj fajla sa imenom key_file_name u 9000h

        mov si, 9000h
        mov al, 10
        call _string_strip

        call _string_parse ; parsira string tako da se u ax nalazi prvi kljuc, a u bx drugi

        mov si, ax
        call _string_to_int ; parsira string iz ax u integer
        mov byte [a_key], al

        mov si, bx
        call _string_to_int ; parsira string iz bx u integer
        mov byte [b_key], al
        popa
        popf
        pop si
        ;--------------------------------------------


        call    _clear_screen               ; Startovati komandni interpreter
        call    _command_line

stop:   mov     si, stop_msg                ; Kada se izadje iz CLI, sistem se zaustavlja.
        call    _print_string
        cli
        hlt

stop_msg   db 13,10, '   >>> Sistem zaustavljen. Mozete iskljuciti racunar.', 0


; ---------------------------------
; Sistemski servisi
; ---------------------------------
    %include "servisi/shell.asm"
    %include "servisi/batch.asm"
    %include "servisi/disk.asm"
    %include "servisi/tastatura.asm"
    %include "servisi/matemat.asm"
    %include "servisi/ostalo.asm"
    %include "servisi/portovi.asm"
    %include "servisi/ekran.asm"
    %include "servisi/zvuk.asm"
    %include "servisi/string.asm"
    %include "servisi/printer.asm"
	  %include "servisi/prekidi.asm"
    %include "servisi/kryptex.asm"
