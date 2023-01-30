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
    jsr vbxe.setup_vbxe_sprite_draw_bcb 
    jsr vbxe.start_blitter 

    jmp main_loop

    rts 
.endp ; main

    icl 'sys_defs.h'
    icl 'vbxe.asm'
    icl 'os.asm'
