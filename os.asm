;##################################################
; os.asm
;##################################################


;##################################################
; replace the OS NMI handler with our own
;##################################################
.proc nmi_handler
    	bit nmires
    	bpl not_dli
    	jmp (VDSLST)
not_dli:
		cld
		pha
		txa
		pha
		tya
		pha
		sta nmires
		jmp (VVBLKI)

		rts
.endp


;##################################################
; default VBI routine when disabling OS
;##################################################
.proc default_vbi_routine	

	lda #$01
	sta default_vblank

	pla
    tay
    pla
    tax
    pla
    rti

.endp

;##################################################
; wait until VBLANK occured
;##################################################
.proc wait_for_default_vblank
@
	lda default_vblank
	cmp #$00
	beq @-

	lda #$00
	sta default_vblank

	rts
.endp 


;##################################################
; use RAM under ROM by setting FE into PORTB
;##################################################
.proc disable_os
    sei
    cld
    lda #$00  
    sta IRQEN
    lda #$00
    sta NMIEN
	lda #$FE
	sta PORTB
	
	mwa #nmi_handler NMI
	mwa #default_vbi_routine VVBLKI

	lda #$40
	sta NMIEN
	
	rts
.endp
;-----------------------


;-----------------------
; variables 
;-----------------------
default_vblank  .byte   0