;*********************************************************
; VBXE.asm
;*********************************************************

; VBXE namespace
.proc vbxe  

;*********************************************************
; proc name:  initialize
; purpose:    initializes VBXE, call this method first
;*********************************************************
.proc initialize
    jsr check_vbxe  

    enable_xdl #0 ; disabled

    jsr setup_vbxe_memac
    jsr setup_vbxe_xdl
    jsr setup_vbxe_clear_screen_bcb
    jsr start_blitter    
    jsr setup_vbxe_palette
    jsr setup_vbxe_sprite_data

    jsr vbxe.setup_vbxe_sprite_draw_bcb 
    jsr vbxe.start_blitter 
    
    enable_xdl #VBXE_VIDEO_CONTROL_XDL_ENABLED ; disable

    
    rts 
.endp ;initialize

;*********************************************************
; proc name:  check_vbxe
; purpose:    as VBXE board has few versions, we need to 
;             check if locations $D600 or $D700 are used
;             if not --> vbxe is not installed 
;*********************************************************
.proc check_vbxe 
    ; set $D600 into base address ZP variable 
    mwa #VBXE_D600 VBXE_BASE_ADDR
    jsr detect_vbxe 
    beq exit_check
    ; if $D600 was not recognized, check $D700
    inc VBXE_BASE_ADDR+1
    jsr detect_vbxe 
    beq exit_check 
    ; no VBXE installed --> set to 0 
    mva #$00 VBXE_BASE_ADDR 

exit_check
    rts 
.endp ;check_vbxe

;*********************************************************
; proc name:  detect_vbxe
; purpose:    check major (core) and minor versions at
;             locations base+40 and base+41 respectively 
;*********************************************************
.proc detect_vbxe
    ; check FX 1.xx (location $40)
    ldy #VBXE_CORE_VERSION
    lda (VBXE_BASE_ADDR),y
    cmp #$10    
    bne exit_detect 
    ; check minor version (location $41)
    ldy #VBXE_MINOR_VERSION
    lda (VBXE_BASE_ADDR),y
    ; the following and was recommended to do in
    ; the VBXE documentation to avoid minor version differences 
    and #$70
    cmp #$20    

exit_detect 
    rts
.endp; detect_vbxe

;*********************************************************
; proc name:  setup_vbxe_memac
; purpose:    set up MEMAC-A memory for VBXE
;             that means set the address space for it
;             choose the access (CPU/VBXE) 
;             and choose the memory size
;*********************************************************
.proc setup_vbxe_memac   
    
	;-------------------------------------------------------    
    ; set MEMAC-A memory 
    ; set the MEMAC-A window address
    ; set CPU access
    ; set 4K size  
	;-------------------------------------------------------
    ldy #VBXE_MEMAC_CTRL
    lda #(>VBXE_MEMC_WINDOW + MEMC_CPU_ENABLE + MEMC_SIZE_4K) 	
	sta	(VBXE_BASE_ADDR),y 	

    rts 
.endp ; setup_vbxe_memac

;*********************************************************
; proc name:  setup_vbxe_xdl
; purpose:    the XDL defines the screen type 
;             resolution, scanlines and other 
;             copy xdl data to MEMAC-A memory window
;             and setup xdl addressed in the vbxe memory 
;             address space 
;*********************************************************
.proc setup_vbxe_xdl 

    ; since we're using a standard resolution screen 
    ; with 320x192 pixels, and each pixel takes 1 byte
    ; the standard resolution screen will take 
    ; the address space $000000-$00EFFF (size of $F000) 
    ; in the VBXE memory address space
    ; so anything else beside the screen memory 
    ; should be above this address (above $00F000)
    ; to set this address we need to select the proper bank
    ; each bank is aligned to $1000 
    ; set XDL to the $00F000 address
    ; select bank $0F where the XDL will reside
    ; and enalbe the MEMAC-A window  
    mva #$0F VBXE_CURRENT_BANK

    ldy #VBXE_MEM_BANK_SEL
    lda VBXE_CURRENT_BANK
    clc 
    adc #MEMAC_GLOBAL_ENABLE
    sta (VBXE_BASE_ADDR),y 

    ; copy the xdl data into the MEMAC-A window address space
    ; then set the XDL address to point to the VBXE addres
    ; space that will be used for the XDL

    ldx #(XDL_DATA_LEN-1)
loop
    lda	XDL_DATA,x 
    sta	VBXE_MEMC_WINDOW,X 
    dex 
    bpl loop 

    ; as explained above, the XDL in VBXE address space will
    ; reside in $00F000 and on
    ; but the XDL data was copied to the MEMAC-A window address
    
    ldy #VBXE_XDL_ADR0      ; low byte
    lda	#$00
	sta	(VBXE_BASE_ADDR),y	
    ldy #VBXE_XDL_ADR1      ; mid byte
    lda #$F0                  
	sta	(VBXE_BASE_ADDR),y	
    ldy #VBXE_XDL_ADR2      ; high byte
    lda #$00
	sta	(VBXE_BASE_ADDR),y	
    
    rts 
.endp ;setup_vbxe_xdl

;*********************************************************
; proc name:  setup_vbxe_palette
; purpose:    copy the rgb palette bin file
;             data into VBXE memory 
;*********************************************************
.proc setup_vbxe_palette

    ; the sprite sheet data contains rgb color data as well
    ; this is reflected in the palette bin file
    ; copy the palette bin file data into VBXE rgb registers
    ; the rgb bin file contains 256 values for 
    ; r,g and b respectively, we copy all of them 
    ; start from palette 0 and color 0
    
    ; select palette 0
    ldy #VBXE_PSEL
    lda #0 
    sta (VBXE_BASE_ADDR),y 

    ; select color 0 
    ldy #VBXE_CSEL
    lda #0 
    sta (VBXE_BASE_ADDR),y 

    ; loop all rgb values
    ldx #0

loop_rgb
    ; red 
    ldy #VBXE_CR
    lda	palette_bin,x 
    sta (VBXE_BASE_ADDR),y 
    ; green 
    ldy #VBXE_CG 
    lda palette_bin+$100,x 
    sta (VBXE_BASE_ADDR),y 
    ; blue
    ldy #VBXE_CB 
    lda palette_bin+$100+$100,x 
    sta (VBXE_BASE_ADDR),y 
    
    ; color selection (VBXE_CSEL) will increment automatically
    inx 
    bne loop_rgb
    
    rts 
.endp ;setup_vbxe_palette

;*********************************************************
; proc name:  setup_vbxe_sprite_data
; purpose:    copy the sprite bin file data 
;             into MEMAC-A window memory 
;             take into account the MEMAC-A window size
;             you have defined and see if the sprite sheet
;             does not exceed that
;*********************************************************
.proc setup_vbxe_sprite_data
    
    ; copy the sprite into the MEMAC-A VBXE address
    ; the offset needs to take into account the XDL
    ; and the blitter blocks so we set the address
    ; to be the MEMAC-A window address + $100 as offset
    ; $100 is enough as we only have 2 blitter blocks  
    ; that takes 2x21 = 42 bytes
    
    ; set the bin file hi byte address 
    ; into a ZP source variable
    mwa #sprite_data ZP_SRC 

    ; set the MEMAC-A window + offset($100) address  
    ; into a ZP destination variable 
    lda #0
    sta ZP_DST 
    lda #>(VBXE_MEMC_WINDOW + $100)
    sta ZP_DST + 1

    ; loop sprite height 
    ldx #SPRITE_HEIGHT
copy_sprite_row_loop
    ldy #SPRITE_HEIGHT-1
copy_sprite_byte_loop
    lda (ZP_SRC),y
    sta (ZP_DST),y
    dey
    bpl copy_sprite_byte_loop
    clc
    lda ZP_SRC
    adc #SPRITE_WIDTH
    sta ZP_SRC
    lda ZP_SRC + 1
    adc #0
    sta ZP_SRC + 1

    clc
    lda ZP_DST 
    adc #SPRITE_WIDTH
    sta ZP_DST 
    lda ZP_DST + 1
    adc #0
    sta ZP_DST + 1

    dex
    bne copy_sprite_row_loop

    rts 
.endp ;setup_vbxe_sprite_data

;*********************************************************
; proc name:  enable_xdl
; parameters: 0=disable, 1=enable
; purpose:    sets 0/1 in VBXE video control to enable
;             or disable the display
;*********************************************************
.proc enable_xdl(.byte x).reg 
    
    ; x-reg holds enable/disable
    ; enable/disable XDL
    ldy #VBXE_VIDEO_CONTROL
    txa 
    sta (VBXE_BASE_ADDR),y 

    rts 
.endp ; enable_xdl

;*********************************************************
; proc name:  start_blitter
; purpose:    once blitter is free (not busy)
;             start 
;*********************************************************
.proc start_blitter 
    ; first wait for blitter busy to finish
    jsr wait_for_blitter

    ldy #VBXE_BLITTER_START
    lda #$01 
    sta (VBXE_BASE_ADDR),y 
    
    rts 

.endp ; start_blitter

;*********************************************************
; proc name:  wait_for_blitter
; purpose:    read the register BLITTER BUSY 
;             and wait till its not busy anymore
;*********************************************************
.proc wait_for_blitter
    ; read the blitter busy register
    ; if it is 0 -->it is ready  
    ldy #VBXE_BLITTER_BUSY
do_wait
    lda (VBXE_BASE_ADDR),y
    bne do_wait 
    
    rts
.endp ; wait_for_blitter

;*********************************************************
; proc name:  setup_vbxe_blitter_block
; purpose:    you need to set before calling this proc
;             ZP_SRC and 3 bytes for VBXE_MEM_ADDR    
;             from the VBXE 3 bytes address 
;             we take the bank , and set it 
;             and we set the ZP_DST 
;             and the 3 bytes blitter address 
;*********************************************************
.proc setup_vbxe_blitter_block
    ; source was set before the call to this proc
    ; set the destination 
    ; the VBXE address is with this format $00-F0-00
    ; we need to get the half part of the high byte
    ; and half part of the mid byte to select the proper
    ; VBXE bank  
    
    ; load mid byte 
    lda VBXE_MEM_ADDR+1 
    ; store it temporary 
    sta ZP_TMP
    ; load high byte 
    lda VBXE_MEM_ADDR+2
    ; 4 shifts 4 rolls to get the half byte and half byte  
    asl ZP_TMP 
    rol 
    asl ZP_TMP 
    rol 
    asl ZP_TMP 
    rol 
    asl ZP_TMP 
    rol 

    ; select the bank for this address of VBXE
    ; restore current bank back 
    ldy #VBXE_MEM_BANK_SEL
    ; acc holds the bank  
    clc 
    adc #MEMAC_GLOBAL_ENABLE
    sta (VBXE_BASE_ADDR),y 

    ; we need to add to the MEMAC-A window the offset 
    ; of the VBXE address 
    lda VBXE_MEM_ADDR
    sta ZP_DST 
    lda VBXE_MEM_ADDR+1
    ; extrac the 3rd digit 
    and #$0F 
    ora #>VBXE_MEMC_WINDOW
    sta ZP_DST+1 

    ; loop copy
    ldy #BCB_SIZE-1

copy_loop
    lda (ZP_SRC),y
    sta (ZP_DST),y
    dey
    bpl copy_loop
    
    ; set the blitter address in VBXE memory address space
    ; $00F00E
    ldy #VBXE_BL_ADR0 ; low byte
    lda VBXE_MEM_ADDR 
    sta (VBXE_BASE_ADDR),y 

    ldy #VBXE_BL_ADR1 ; mid byte
    lda VBXE_MEM_ADDR+1   
    sta (VBXE_BASE_ADDR),y 

    ldy #VBXE_BL_ADR2 ; high byte
    lda VBXE_MEM_ADDR+2 
    sta (VBXE_BASE_ADDR),y 


    ; restore current bank back 
    ldy #VBXE_MEM_BANK_SEL
    lda VBXE_CURRENT_BANK  
    clc 
    adc #MEMAC_GLOBAL_ENABLE
    sta (VBXE_BASE_ADDR),y 

    rts 
.endp ;setup_vbxe_blitter_block

;*********************************************************
; proc name:  setup_vbxe_clear_screen_bcb
; purpose:    set up the ZP_SRC to bcb clear screen data
;             set up the vbxe address to $00F00E
;             the bank will be $0F as the MEMAC window is set 
;             to 4K size so all banks addresses are 
;             aligned with $1000 
;*********************************************************
.proc setup_vbxe_clear_screen_bcb
    ; copy the blitter address to ZP source varialbe 
    mwa #BCB_CLEAR_SCREEN ZP_SRC
    
    ; set blitter block to $00F00E
    mva #$0E VBXE_MEM_ADDR
    mva #$F0 VBXE_MEM_ADDR+1
    mva #$00 VBXE_MEM_ADDR+2

    jsr setup_vbxe_blitter_block

    rts
.endp ;setup_vbxe_clear_screen_bcb 

;*********************************************************
; proc name:  setup_vbxe_sprite_draw_bcb
; purpose:    set up the ZP_SRC to bcb sprite draw data
;             set up the vbxe address to $00F023
;             each blitter block is 21 bytes and last
;             block was set to $00F00E
;             the bank will be $0F again as the MEMAC window is set 
;             to 4K size so all banks addresses are 
;             aligned with $1000 
;*********************************************************
.proc setup_vbxe_sprite_draw_bcb
    
    ; copy the blitter address to ZP source varialbe 
    mwa #BCB_SPRITE_DRAW ZP_SRC
    
    ; set blitter block to $00F00E
    mva #$23 VBXE_MEM_ADDR
    mva #$F0 VBXE_MEM_ADDR+1
    mva #$00 VBXE_MEM_ADDR+2

    jsr setup_vbxe_blitter_block

    rts
.endp ;setup_vbxe_sprite_draw_bcb 

;---------------------------------------------
; include files
    icl 'vbxe.h'
    icl 'xdl_data.h'
    icl 'bliiter_blocks.h'
sprite_data
    ins 'sprite_monster.bin'
palette_bin
    ins 'palette_monster.bin'
;---------------------------------------------

.endp; vbxe 