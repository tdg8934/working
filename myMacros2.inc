; --------------------------------
;
;     SOME MORE USEFUL MACROS
;
; --------------------------------


	macro CREATE_BITMAP id, width, height, data
	.db 23, 27, 0, id			
; select bitmap id
	.db 23, 27, 1				
; create bitmap with width, height...
	.dw width, height
; add width, height as words
	incbin data
	endmacro






































