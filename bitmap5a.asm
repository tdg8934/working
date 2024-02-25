    ;extra MACRO files need to go here
    include "myMacros.inc"
    include "myMacros2.inc"


    .assume adl=1                       ; ez80 ADL memory mode
    .org $40000                         ; load code here

    jp start_here                       ; jump to start of code

    .align 64                           ; MOS header
    .db "MOS",0,1     

start_here:
            
    push af                             ; store all the registers
    push bc
    push de
    push ix
    push iy

; ---------------------------------------------
; This is our actual code
; ---------------------------------------------

; prepare the screen
    SET_MODE 8                          ; mode 8 is 320x240 pixels, 64 colours

; define stream of data to send to VDP
    ld hl, data_start
    ld bc, data_end - data_start
    rst.lil $18

    call draw_map1
    
    ld a, J1
    ld (which_bitmap), a
    ld a, 64
    ld (bitmap_x), a
    ld a, 128
    ld (bitmap_y), a
    call draw_bitmap                    ; this routine will plot bitmap 'which_bitmap, at position bitmap_x, bitmap_y


    MOSCALL $08                         ; get IX pointer to System Variables

; ---------------------------------------------
; MAIN LOOP
; ---------------------------------------------

WAIT_HERE:                              ; loop here until we hit ESC key
    ld a, (ix + $05)                    ; get ASCII code of key pressed
    cp 27                               ; check if 27 (ascii code for ESC)   
    jp z, EXIT_HERE                     ; if pressed, jump to exit

    jr WAIT_HERE

; ---------------------------------------------
; This is where we exit the program
; ---------------------------------------------

EXIT_HERE:

    CLS 

    pop iy                              ; Pop all registers back from the stack
    pop ix
    pop de
    pop bc
    pop af
    ld hl,0                             ; Load the MOS API return code (0) for no errors.
    ret                                 ; Return to MOS

; ---------------------------------------------
; FUNCTIONS
; ---------------------------------------------

draw_bitmap:
    ld hl, draw_bmStart
    ld bc, draw_bmEnd - draw_bmStart
    rst.lil $18
    ret 



draw_map1:
draw_outer_wall:
    ld a, W7		 ;wall bitmap
    ld (which_bitmap), a ;bitmap number

start_bytex0:
    ld a, 0		;start of (byte) x position
testx0:
    cp 240		;compare to end of (byte) x position
    jp z, start_bytex1
    ld (bitmap_x), a
    push af
    ld a, 0
    ld (bitmap_y), a	;start of (byte) y position
    pop af
    push af
    call draw_bitmap          
    pop af
    add a, 16
    jr testx0

start_bytex1:
    ld a, 0		;start of (byte) x position
testx1:
    cp 240		;compare to end of (byte) x position
    jp z, start_bytey0
    ld (bitmap_x), a
    push af
    ld a, 224
    ld (bitmap_y), a	;start of (byte) y position
    pop af
    push af
    call draw_bitmap          
    pop af
    add a, 16
    jr testx1   

start_bytey0:
    ld a, 0		;start of (byte) y position
testy0:
    cp 240		;compare to end of (byte) y position
    jp z, start_bytey1
    ld (bitmap_y), a
    push af
    ld a, 0
    ld (bitmap_x), a	;start of (byte) x position
    pop af
    push af
    call draw_bitmap          
    pop af
    add a, 16
    jr testy0

start_bytey1:
    ld a, 0		;start of (byte) y position
testy1:
    cp 240		;compare to end of (byte) y position
    jp z, testx0_word_start
    ld (bitmap_y), a
    push af
    ld bc, 304		;end of (word) x position
    ld a, c
    ld (bitmap_x), a	;start of (byte) x position
    ld a, b
    ld (bitmap_x+1), a  
    pop af
    push af
    call draw_bitmap          
    pop af
    add a, 16
    ld a, 0
   ; ld (bitmap_x+1), a		;clear out x+1
    jr testy1   

  
testx0_word_start:		;start of (word) x positions (320)
;    ld bc, 240
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 256
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 272
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 288
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 304
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap 
;    ld a, 0
;    ld (bitmap_x+1), a		;clear out x+1 and y+1
;    ld (bitmap_y+1), a               
;testx0_word_end:
    

;testx1_word_start:		;start of (word) x positions (320)
;    ld bc, 240
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 224
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 256
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 224
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 272
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 224
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 288
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 224
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld bc, 304
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 224
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld a, 0
;    ld (bitmap_x+1), a		;clear out x+1 and y+1
;    ld (bitmap_y+1), a
;testx1_word_end:
    
;    ld a, W8			;add a door into the wall
;    ld (which_bitmap), a
;    ld a, 144
;    ld (bitmap_x), a
;    ld a, 224
;    ld (bitmap_y), a
;    call draw_bitmap                



;draw_inner_wall:
;    ld a, W7  		 ;wall bitmap
;    ld (which_bitmap), a ;bitmap number

;start_bytex0_I:
;   ; ld a, 0		;start of (byte) x position
;     ld a, 32
;testx0_I:
;   ; cp 240		;compare to end of (byte) x position
;     cp 208
;    jp z, start_bytex1_I
;    ld (bitmap_x), a
;    push af
;   ; ld a, 0
;    ld a, 32
;    ld (bitmap_y), a	;start of (byte) y position
;    pop af
;    push af
;    call draw_bitmap          
;    pop af
;    add a, 16
;    jr testx0_I

;start_bytex1_I:
;   ; ld a, 0		;start of (byte) x position
;     ld a, 32
;testx1_I:
;   ; cp 240		;compare to end of (byte) x position
;     cp 208
;    jp z, start_bytey0_I
;    ld (bitmap_x), a
;    push af
;   ; ld a, 224
;     ld a, 192
;    ld (bitmap_y), a	;start of (byte) y position
;    pop af
;    push af
;    call draw_bitmap          
;    pop af
;    add a, 16
;    jr testx1_I   

;start_bytey0_I:
;   ; ld a, 0		;start of (byte) y position
;     ld a, 32
;testy0_I:
;   ; cp 240		;compare to end of (byte) y position
;     cp 208
;    jp z, start_bytey1_I
;    ld (bitmap_y), a
;    push af
;   ; ld a, 0
;     ld a, 32
;    ld (bitmap_x), a	;start of (byte) x position
;    pop af
;    push af
;    call draw_bitmap          
;    pop af
;    add a, 16
;    jr testy0_I

;start_bytey1_I:
;   ; ld a, 0		;start of (byte) y position
;     ld a, 32
;testy1_I:
;   ; cp 240		;compare to end of (byte) y position
;     cp 224
;    jp z, testx0_word_start_I
;    ld (bitmap_y), a
;    push af
;   ; ld bc, 304		;end of (word) x position
;     ld bc, 272
;    ld a, c
;    ld (bitmap_x), a	;start of (byte) x position
;    ld a, b
;    ld (bitmap_x+1), a   
;    pop af
;    push af
;    call draw_bitmap          
;    pop af
;    add a, 16
;    ld a, 0
;    ld (bitmap_x+1), a		;clear out x+1
;    jr testy1_I   ;

  
testx0_word_start_I:		;start of (word) x positions (320)
;   ; ld bc, 240
;     ld bc, 208
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 256
;     ld bc, 224
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 272
;     ld bc, 240
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 288
;     ld bc, 256
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 304
;     ld bc, 272
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;    ld bc, 0
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap 
;    ld a, 0
;    ld (bitmap_x+1), a		;clear out x+1 and y+1
;    ld (bitmap_y+1), a               
;    ld a, 0
;    ld (bitmap_x+1), a		;clear out x+1 and y+1
;    ld (bitmap_y+1), a
;testx0_word_end_I:
    

;testx1_word_start_I:		;start of (word) x positions (320)
;   ; ld bc, 240
;     ld bc, 208
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;   ; ld bc, 224
;     ld bc, 192
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 256
;     ld bc, 224
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;   ; ld bc, 224
;     ld bc, 192
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 272
;     ld bc, 240
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;   ; ld bc, 224
;     ld bc, 192
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 288
;     ld bc, 256 
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;   ; ld bc, 224
;     ld bc, 192
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;   ; ld bc, 304
;     ld bc, 272
;    ld a, c
;    ld (bitmap_x), a
;    ld a, b
;    ld (bitmap_x+1), a
;   ; ld bc, 224
;     ld bc, 192
;    ld a, c
;    ld (bitmap_y), a
;    ld a, b
;    ld (bitmap_y+1), a
;    call draw_bitmap                
;    ld a, 0
;    ld (bitmap_x+1), a		;clear out x+1 and y+1
;    ld (bitmap_y+1), a
;testx1_word_end_I:


    ret


; ------------------
  
draw_bmStart:
    		.db 23, 27, 0		 ; select bitmap
which_bitmap:	.db 0			 ; bitmap number
		.db 25, $ED	         ; plot bitmap at x,y
bitmap_x:	.dw 0	      	         ; to x pos (a word not a byte)
bitmap_y:	.dw 0		         ; to y pos (a word not a byte)
draw_bmEnd:	


; ---------------------------------------------
; DATA
; ---------------------------------------------

data_start:
    .db     23, 0, $C0, 0                   ; set screen to non-scaled
    CREATE_BITMAP J0, 16, 16, "J0.data"     ; the macro sorts all of this out 
    CREATE_BITMAP J1, 16, 16, "J1.data"
    CREATE_BITMAP J2, 16, 16, "J2.data"
    CREATE_BITMAP J3, 16, 16, "J3.data"
    CREATE_BITMAP J4, 16, 16, "J4.data"
    CREATE_BITMAP J5, 16, 16, "J5.data"
    CREATE_BITMAP J6, 16, 16, "J6.data"
    CREATE_BITMAP J7, 16, 16, "J7.data"
    CREATE_BITMAP J8, 16, 16, "J8.data"
    CREATE_BITMAP J9, 16, 16, "J9.data"
    CREATE_BITMAP K5, 16, 16, "K5.data"
    CREATE_BITMAP K6, 16, 16, "K6.data"
    CREATE_BITMAP W0, 16, 16, "W0.data"
    CREATE_BITMAP W7, 16, 16, "w7.data"
    CREATE_BITMAP W8, 16, 16, "W8.data"
    CREATE_BITMAP W9, 16, 16, "W9.data"
    CREATE_BITMAP star,    16, 16, "star.data"
    CREATE_BITMAP crystal, 16, 16, "crystal.data"
data_end:

; ---------------------------------------------
; define EQUs
; ---------------------------------------------

J0:     equ 0
J1:     equ 1
J2:     equ 2
J3:     equ 3
J4:     equ 4
J5:     equ 5
J6:     equ 6
J7:     equ 7
J8:     equ 8
J9:     equ 9
K5:     equ 10
K6:     equ 11
W0:     equ 12
W7:     equ 13
W8:     equ 14
W9:     equ 15
star:     equ 16
crystal:  equ 17










































