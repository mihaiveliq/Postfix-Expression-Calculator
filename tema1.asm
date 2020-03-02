%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .bss
	expr: resb MAX_INPUT_SIZE

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp

        GET_STRING expr, MAX_INPUT_SIZE
        
        lea esi, [expr] ; Mut in esi adresa sirului
        mov ecx, 1  ; Ecx va contine mereu semnul numarului curent
                    ; 1 pentru pozitiv si -1 pentru negativ
        push 0  ; Atunci cand primul numar din sir nu are semnul minus
                ; e nevoie de un 0 pe stiva pt. a construi primul numar 
        
        ; Ne vom intoarce aici dupa fiecare procesare a fiecarui caracter 
        ; din sir, prelucrand pas cu pas rezultatul
read_number:
        ; Golim registrii cu care vom lucra
        xor eax, eax ; In eax vom stoca numerele
        xor ebx, ebx
        xor edx, edx
        
        ; Incepe convertirea in cifre si operatii in functie de caracter
        lodsb
        ; Daca suntem la finalul sirului scoatem rezultatul de pe stiva
        ; si il afisam
        cmp al, 0
        je finish
        
        cmp al, ' '
        je space
        
        cmp al, '+'
        je plus
        
        cmp al, '-'
        je minus
        
        cmp al, '/'
        je divide
        
        cmp al, '*'
        je multiply
        
        cmp al, '9'
        jle if_grater_equal_zero
        
if_grater_equal_zero:
        ;Verific daca este o cifra intre 0 si 9
        cmp al, '0'
        jge convert_digit

space:
        ; Resetam semnul si trecem la un nou numar 
        mov ecx, 1
        jmp read_number

plus:
        ; Scot de pe stiva al doilea operand
        pop ebx
        ; Scot de pe stiva primul operand
        pop edx
        ; Salvez suma in edx
        add edx, ebx
        ; Pun suma pe stiva
        push edx
        jmp read_number

minus:
        ; Verific daca minusul este operatie sau semn al
        ; Vreunui numar in functie de pozitia fata de spatiu
        cmp byte[esi], ' '
        jne signed_number
        ; Daca nu este semnul unui numar sau daca este ultima operatie
last_operation:
        ; Scot de pe stiva al doilea operand
        pop ebx
        ; Scot de pe stiva primul operand
        pop edx
        ; Salvez diferenta in edx
        sbb edx, ebx
        ; Pun diferenta pe stiva
        push edx
        jmp read_number

divide:
        ; Scot impartitorul de pe stiva
        pop ebx
        ; Scot deimpartitul de pe stiva
        pop eax
        ; Salvez semnul in edx
        cdq
        ; Catul ramane in eax
        idiv ebx
        ; Pun catul pe stiva
        push eax
        jmp read_number

multiply:
        ; Scot inmultitorul de pe stiva
        pop ebx
        ; Scot deimpartitul de pe stiva
        pop eax
        ; Produsul ramane in eax
        imul ebx
        ; Pun produsul pe stiva
        push eax
        jmp read_number

signed_number:
        ; Daca minusul se afla la sfarsitul sirului inseamna 
        ; ca este operatie si nu semnul numarului
        cmp byte[esi], 0
        je last_operation
        ; Semnul va fi minus pana se trece la un nou numar
        mov ecx, -1
        jmp read_number
        
convert_digit:
        ; Convertesc caracterele in intregi folosindu-ma de
        ; codul ASCII
        sub eax, 48
        ; Ii setez semnul
        imul ecx
        ; Trimit cifra spre evaluare
        jmp eval_digit
    
eval_digit:
        ; Daca este prima cifra dintr-un numar o urc direct 
        ; pe stiva
        cmp byte[esi - 2], ' '
        je urca_pe_stiva
        cmp byte[esi - 2], '-'
        je urca_pe_stiva
        ; Daca nu este prima cifra:
        ; Salvez temporar cifra in edx
        mov edx, eax
        ; Iau de pe stiva prima parte a numarului
        pop eax
        ; Pun pe stiva cifra care trebuie adaugata
        push edx
        ; Inmultesc cu 10 prima parte a numarului
        mov ebx, 10
        imul ebx
        ; Scot de pe stiva cifra care trebuie adaugata
        ; si o adaug
        pop edx
        add eax, edx
        ; Pun pe stiva numarul actualizat
        push eax
        jmp read_number
        
urca_pe_stiva:
        ;Punem pe stiva numarul stocat in eax
        push eax
        jmp read_number
                              
finish:
        ;Scoatem rezultatul final de pe stiva si il afisam
        pop eax
        PRINT_DEC 4, eax
        NEWLINE
        ;Daca sirul nu a inceput cu un minus este necesar
        ;sa scoatem de pe stiva 0 ul pus la inceput 
        cmp byte[expr], '-'
        jne no_pop_zero
        pop ebx
 no_pop_zero:       
	xor eax, eax
	pop ebp
	ret
