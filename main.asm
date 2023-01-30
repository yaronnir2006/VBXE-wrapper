; main.asm

    org $2000

.proc main

    ; turn off ANTIC DMA
    mva #$00 DMACTL

    ; disable OS
    jsr disable_os

    ; init VBXE
    jsr vbxe.initialize
    
main_loop
    jsr wait_for_default_vblank

    ; screen address is $BC40 (for default display list)
    ldx #4
loop_text
    lda text,x 
    sta $BCFF,x 
    dex 
    bpl loop_text


    jmp main_loop

    rts 
.endp ; main

text 
    dta 'v','b','x','e'

    icl 'sys_defs.h'
    icl 'vbxe.asm'
    icl 'os.asm'
