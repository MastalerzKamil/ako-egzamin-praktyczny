.686
.model flat
public _find_in_last
.data
.code
_find_in_last PROC
	push ebp
	mov ebp, esp
	push ebx	;odkladanie zgodne ze standardem C
	push esi
	push edi
	push ecx
	mov edi, [ebp+8]	; *last
	mov bx, [ebp+16]	; znak
	; szukanie dlugosci lancucha znakow
	cld	; aby edi roslo w gore
	mov ax, 0	; warunek koncowy- koniec lancucha
	mov ecx, -1	; przeszukaj cala pamiec
	repne scasw
	neg ecx	; aby byla zawsze wartosc dodatnia dlugosci
	sub ecx, 1; odejmij  znak '0' 
	
szukaj_znaku:
	cmp [edi+4*ecx], bx	; zaladuj kolejny znak z last. Jeden element last = znak (2 bajty)+indeks(2 bajty)
	jz znaleziono
	dec ecx
	jnz szukaj_znaku
znaleziono:
	mov ax, [edi+4ecx+2]	; indeks znaku ze wzorca z tablicy last
	pop ecx
	pop edi
	pop esi
	pop ebp
	ret
_find_in_last ENDP
END