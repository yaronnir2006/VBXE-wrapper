; blitter blocks

;-----------------------------------------------
; blit data for "sprite"
;-----------------------------------------------
BCB_SPRITE_DRAW
    ; BCB is 21 bytes long
    ; 3 bytes = address of the sprite data we are copying
    ; our sprite resides in VBXE memory $00F100
    dta $00
    dta $F1
    dta $00
    ; step Y - sprite width for each change of Y
    dta a(SPRITE_WIDTH)
    ; step X - step 1 byte each change of X
    dta $1
    ; the address of middle of the VBXE visible screen
    dta $80
    dta $50
    dta $00
    ; step Y - screen width in pixels $140 (320) 
    dta a($140)
    dta $1
    ; width of blitter to copy  
    dta a(SPRITE_WIDTH - 1)
    ; height of blitter to copy 
    dta SPRITE_HEIGHT - 1
    ; AND mask for source
    dta $FF
    ; XOR mask for source
    dta $00 
    ; AND mask collision detection
    dta $00 
    ; ZOOM value X-Axis Y-Axis
    dta $00
    ; Pattern fill 
    dta $00
    dta $01

;-----------------------------------------------
; blit data for clear screen
;-----------------------------------------------
BCB_CLEAR_SCREEN 
    ; BCB is 21 bytes long
    ; 3 bytes = address of the sprite data we are copying
    ; our sprite resides in VBXE memory $00F100
    dta $00
    dta $00
    dta $00
    ; step Y - sprite width for each change of Y
    dta a($0000) ; 320 - screen width
    ; step X - step 1 byte each change of X
    dta $0
    ; the address of the VBXE screen top left
    dta $00
    dta $00
    dta $00
    ; step Y - screen width in pixels $140 (320) 
    dta a($140)
    ; step X - 1 pixel 
    dta $01
    ; width of blitter to copy  
    dta a($140 - 1) 
    ; height of blitter to copy 
    dta $C0-$1 
    ; AND mask for source
    dta $00
    ; XOR mask for source
    dta $00
    ; AND mask collision detection
    dta $00 
    ; ZOOM value X-Axis Y-Axis
    dta $00
    ; Pattern fill 
    dta $00
    dta $00

BCB_SIZE equ 21

