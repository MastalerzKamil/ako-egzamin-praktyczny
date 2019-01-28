.686
.model flat
public _search
.data
wzorzec_dl	dd 0
adr_last	dd ?
.code
_search PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	push ecx
	mov esi, [ebp+8]	; *tekst
	mov edi, [ebp+12]	; *wzorzec
	; szukanie dlugosci wzorca
	cld	; aby edi roslo w gore
	mov ecx, -1	; do przeszukiwania calej pamieci
	mov eax, 0
	repne scasw	; przeszukaj caa pamiec aby znalezc dlugosc napisu
	neg ecx
	sub ecx, 1	; odejmij od dlugosci napisu zera na koncu
	mov wzorzec_dl, ecx
	mov edi, [ebp+12]	; *wzorzec
	push edi
	push esi
	call _create_last	; stworz tablice last
	add esp, 8
	mov adr_last, eax	; zapamietaj utworzona tablice last
	mov ebx, 0
szukaj_wzorca:
	cmp [esi], word ptr 0
	jz nie_znaleziono
	mov bx, [edi+2*ecx]
	cmp [esi+2*ecx], bx
	jnz porownaj_dalej ; znaki nie sa podobne wiec trzeba sprawdzic czy znak jest w alfabecie tekstu
	dec ecx	; znaki sa podobne, szukaj dalej po wzorcu
	jnz szukaj_wzorca
	sub esi, [ebp+8]	; odejmij od adresu aktualnego (wyzszego niz poczatkowo) poczatkowy adres w celu znalezienia indeksu poczatku wzorca
	sar esi, 2
	mov eax, esi
	jmp koniec
nie_znaleziono:
	mov eax, -1
	jmp koniec
porownaj_dalej:
	mov ecx, wzorzec_dl
	push ebx	; znak
	push dword ptr offset adr_last
	call _find_in_last	; szukam znaku ze wzorca w tablicy last
	add esp,8	; zwolnij miejsce zgodnie ze standardem C
	cmp eax, -1	; brak znaku w last
	jz przesun_o_dlugosc_okna	; okno=dlugosc wzorca
	push ecx	; zapamietaj dlugosc wzorca
	sub ecx, eax
	cmp ecx, 1
	ja wiekszy_od_1
	inc esi
	pop ecx	; przywroc dlugosc wzorca
	jmp szukaj_wzorca
wiekszy_od_1:
	add esi, ecx	; zwieksz o max(j-find_in_last()last,wzorzec[i-j])
	pop ecx	; przywroc dlugosc wzorca
	jmp szukaj_wzorca
przesun_o_dlugosc_okna:
	add esi, ecx
	jmp szukaj_wzorca
koniec:
	pop ecx
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_search ENDP
END