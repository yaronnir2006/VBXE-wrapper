;-------------------------------------------
; vbxe.h
;-------------------------------------------

;-------------------------------------------
; zero page base address for easy and fast access
VBXE_BASE_ADDR    equ $A0 ; 2 bytes
VBXE_CURRENT_BANK equ $A2 ; 1 byte
VBXE_MEM_ADDR     equ $A3 ; 3 bytes
;-------------------------------------------
; D600/D700
VBXE_D600 equ $D600 
;-------------------------------------------

;-------------------------------------------
; MEMAC-A window address
VBXE_MEMC_WINDOW equ $9000
;-------------------------------------------

;-------------------------------------------
; VBXE main registers 
; some of the registeres can be r/w  
VBXE_VIDEO_CONTROL equ $40  ; write
VBXE_CORE_VERSION  equ $40  ; read

VBXE_XDL_ADR0      equ $41  ; write
VBXE_MINOR_VERSION equ $41  ; read

VBXE_XDL_ADR1 equ $42 ; write
VBXE_XDL_ADR2 equ $43 ; write 

VBXE_CSEL equ $44 ; write 
VBXE_PSEL equ $45 ; write 

VBXE_CR equ $46 ; write
VBXE_CG equ $47 ; write
VBXE_CB equ $48 ; write 

VBXE_COLMASK equ $49 ; write

VBXE_COLCLR    equ $4A ; write
VBXE_COLDETECT equ $4A ; read

; 4B-4F skipped, no use

VBXE_BL_ADR0            equ $50 ; write 
VBXE_BLT_COLLISION_CODE equ $50 ; read

VBXE_BL_ADR1            equ $51 ; write 
VBXE_BL_ADR2            equ $52 ; write 

VBXE_BLITTER_START equ $53 ; write
VBXE_BLITTER_BUSY  equ $53 ; read 

VBXE_IRQ_CONTROL equ $54 ; write 
VBXE_IRQ_STATUS  equ $54 ; read 

VBXE_P0 equ $55 ; write
VBXE_P1 equ $56 ; write
VBXE_P2 equ $57 ; write
VBXE_P3 equ $58 ; write

; 59-5C skipped, no use

VBXE_MEMAC_B_CONTROL equ $5D ; write 
VBXE_MEMAC_CTRL      equ $5E ; write & read

VBXE_MEM_BANK_SEL equ $5F ; write & read 
;-----------------------------------------

;-----------------------------------------
; Video Control attributes
VBXE_VIDEO_CONTROL_XDL_ENABLED                  equ %00000001
VBXE_VIDEO_CONTROL_16_SHADES_ENABLED            equ %00000010
VBXE_VIDEO_CONTROL_DISABLE_OVERLAY_TRASPARENCY  equ %00000100
VBXE_VIDEO_CONTROL_ADD_ADDITINAL_TRANSPARENCY   equ %00001000
;-----------------------------------------

;-----------------------------------------
; MEMAC attributes
MEMC_SIZE_4K        equ %00000000   ; 4k size
MEMC_SIZE_8K        equ %00000001   ; 8k size
MEMC_SIZE_16K       equ %00000010   ; 16k size
MEMC_SIZE_32K       equ %00000011   ; 32k size
MEMC_ANTIC_ENABLE   equ %00000100   ; ANTIC window access
MEMC_CPU_ENABLE     equ %00001000   ; CPU window access 
;-----------------------------------------

;-----------------------------------------
; MEMS (MEMAC BANK SELECTION)
MEMAC_GLOBAL_ENABLE equ %10000000   ; enable the MEMAC window
;-----------------------------------------

;-----------------------------------------
; XDLC controls definition

; first byte 
XDLC_TMON   equ %00000001 ; Overlay text mode
XDLC_GMON   equ %00000010 ; Overlay graphics mode
XDLC_OVOFF  equ %00000100 ; disable overlay  
XDLC_MAPON  equ %00001000 ; enable color attributes
XDLC_MAPOFF equ %00010000 ; disavble color attributes
XDLC_RPTL   equ %00100000 ; repeat for the next x scanlines
XDLC_OVADR  equ %01000000 ; set the address of the Overlay display memory (screen memory) and the step of the overlay display (how many pixels per line) 
XDLC_OVSCRL equ %10000000 ; set scrolling values for the text mode
; second byte 
XDLC_CHBASE equ %00000001 ; sets the font (text mode)
XDLC_MAPADR equ %00000010 ; sets the address and step of the colour attribute map
XDLC_MAPPAR equ %00000100 ; sets the scrolling values, width and height of a field in the colour attribute map
XDLC_ATT    equ %00001000 ; sets the display size(Narrow=256 pixels, Normal=320 pixels, Wide = 336 pixels) the Overlay priority to the ANTIC display and the Overlay color modification
XDLC_HR     equ %00010000 ; enables the high resolution mode, works only with graphics mode, 640 pixels with 16 colors supported 
XDLC_LR     equ %00100000 ; enables the low resolution mode, works only with graphics mode, 160 pixels with 256 colors supported 
; bit 6 in second byte is not in use (reserved)
XDLC_END    equ %10000000 ; ends the XDL and wait for VSYNC to occur

;-----------------------------------------
; XDLC XDLC_ATT first byte attributes
; OV_WIDTH
XDLC_ATT_OV_WIDTH_NARROW equ %00000000 ; bit 0,1=00(256 pixels)
XDLC_ATT_OV_WIDTH_NORMAL equ %00000001 ; bit 0,1=01(320 pixels)
XDLC_ATT_OV_WIDTH_WIDE   equ %00000010 ; bit 0,1=10(336 pixels)
; XDL OV PALETTE
XDLC_ATT_OV_PALETTE_00   equ %00000000 ; bit 4,5=00
XDLC_ATT_OV_PALETTE_01   equ %00010000 ; bit 4,5=01
XDLC_ATT_OV_PALETTE_10   equ %00100000 ; bit 4,5=10
XDLC_ATT_OV_PALETTE_11   equ %00110000 ; bit 4,5=11
; XDL PF PALETTE
XDLC_ATT_PF_PALETTE_00   equ %00000000 ; bit 6,7=00
XDLC_ATT_PF_PALETTE_01   equ %01000000 ; bit 6,7=01
XDLC_ATT_PF_PALETTE_10   equ %10000000 ; bit 6,7=10
XDLC_ATT_PF_PALETTE_11   equ %11000000 ; bit 6,7=11
;-----------------------------------------
; XDLC XDLC_ATT second byte attributes
; MAIN_PRIORITY
XDLC_ATT_MAIN_PRIORITY_OVERLAY_PM0      equ %00000001 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_PM1      equ %00000010 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_PM2      equ %00000100 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_PM3      equ %00001000 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_PF0      equ %00010000 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_PF1      equ %00100000 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_PF2_PF3  equ %01000000 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_COLBK    equ %10000000 
XDLC_ATT_MAIN_PRIORITY_OVERLAY_ALL      equ %11111111
;-----------------------------------------

;-----------------------------------------
; sprite sheet definitions
SPRITE_WIDTH    equ 28;16
SPRITE_HEIGHT   equ 81;21
;-----------------------------------------
