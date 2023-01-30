; main.asm

    org $2000

.proc main
    ; disable OS
    jsr disable_os

    ; init VBXE
    jsr vbxe.initialize

    mva #<dlist_antic4 DLISTL
    mva #>dlist_antic4 DLISTH 

    mva #>charset CHBASE

    mva #$30  COLPF0
    mva #$40  COLPF1
    mva #$50  COLPF2 
    mva #$60  COLPF3
    mva #$44  COLBK

main_loop
    jsr wait_for_default_vblank
    jmp main_loop

    rts 
.endp ; main

    org $4000 
dlist_antic4 
    dta $70,$70,$70  ; 3 blank 8 scanmode lines
    dta $44,$00,$50  ; set screen address to $5000
:23 dta $04          ; 24 scanmode lines with Antic 4
    dta $41,$00,$40  ; dlist jump back to $4000

    org $6000
charset
    ins 'charset.bin'

    org $5000 
screen 
    ins 'screen.bin'

    org $3000 
    icl 'sys_defs.h'
    icl 'vbxe.asm'
    icl 'os.asm'
