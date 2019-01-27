.686
.model flat
public _create_last
extern _VirtualAlloc@16 : PROC
.data
last_dl	dd 0
tekst_dl	dd 0
.code
_create_last PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	push ecx
	mov edi, [ebp+8]	; *tekst
	; liczenie dlugosci tekstu
	cld	; aby edi roslo w gore
	mov ax, 0	; warunek konca tekstu
	mov ecx, -1	; przeszukaj cala pamiec
	repne scasw	; szukaj dlugosc tekstu
	neg ecx
	sub ecx, 1	; odejmij znak koncatekstu
szukaj_alfabetu:
	mov bx, [esi+2*ecx]	; w bx znak do porownania
	push ecx
	dec ecx	; do sprawdzenia wczesniejszego znaku
szukaj_duplikatu:
	cmp [esi+2*ecx], bx
	jz koniec_szukania_duplikatu
	dec ecx
	jnz szukaj_duplikatu

	inc eax	; nie bylo duplikatu po przejsciu wczesniejszych znakow = unikatowy znak
koniec_szukania_duplikatu:
	pop ecx
	dec ecx
	jnz szukaj_alfabetu
	; mam dlugosc alfabetu tekstu w eax wiec  moe zaalokowac pamiec
	sal eax, 4	; pomnoz razy 4 bo znak(2 bajty)+liczba(2 bajty)=4 bajty
	push dword ptr 0	; flProtect
	push dword ptr 0	; flAllocationType
	push eax	; dwSize
	push dword ptr 0	; lpAddress
	mov last_dl, eax
	call _VirtualAlloc@16	; zaalokuj pamiecdo eax
	; nie zwalniam pamieci bo to standard StdCall
	mov edi, eax	; zaalokowany adres tablicy z eax skopiuj do edi
	mov ecx, tekst_dl
	mov esi , [ebp+8]	; *tekst
uzupelnij_last:
	mov bx, [esi+2*ecx]	; zaladuj kolejny znak do bx
	push ecx
	dec ecx
szukaj_duplikatu_do_last:
	cmp bx, [esi+2*ecx]
	jz znaleziono_duplikat_do_last
	dec ecx
	jnz szukaj_duplikatu_do_last
	mov [edi], bx
znaleziono_duplikat_do_last:
	pop ecx
	dec ecx
	jz szukaj_duplikatu_do_last

	pop ecx
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_create_last ENDP
END