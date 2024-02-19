; --------------------------------
;
;     SOME MORE USEFUL MACROS
;
; --------------------------------


	macro CREATE_BITMAP id, w, h, data
	.db 23, 27, 0, id			
; select bitmap id
	.db 23, 27, 1				
; create bitmap with w, h...
	.dw w, h
; add w,h as words
	incbin data
	endmacro













































