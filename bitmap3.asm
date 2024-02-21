    ; extra MACRO files need to go here
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
    SET_MODE 8                          ; mode 8 is 640x480 pixels, 64 colours

; define stream of data to send to VDP
    ld hl, data_start
    ld bc, data_end - data_start
    rst.lil $18

; here we draw a few bitmaps, just as examples
    ld a, J0
    ld (which_bitmap), a
    ld a, 10
    ld (bitmap_x), a
    ld a, 50
    ld (bitmap_y), a
    call draw_bitmap                    ; this routine will plot bitmap 'which_bitmap, at position bitmap_x, bitmap_y

    ld a, J1
    ld (which_bitmap), a
    ld a, 35
    ld (bitmap_x), a
    ld a, 200
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

; ------------------
  
draw_bmStart:
    		.db 23, 27, 0		 ; select bitmap
which_bitmap:	.db 0			 ; bitmap number
		.db 25, $ED		         ; plot bitmap at x,y
bitmap_x:	.dw 0			     ; to x pos (a word not a byte)
bitmap_y:	.dw 0			     ; to y pos (a word not a byte)
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
W8:     equ 13
W9:     equ 14
star:     equ 15
crystal:     equ 16










































