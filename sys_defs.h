;##################################################
; sys_defs.h 
;##################################################


;##################################################
; Zero Page
;##################################################
ZP_SRC  equ $B0
ZP_DST  equ $B2
ZP_TMP  equ $B3
;##################################################
; dli & vbi vectors
;##################################################
VDSLST                  equ $200
VVBLKI                  equ $222
;##################################################
; display list
;##################################################
LMS                 equ 64
DLIST_HSCROLL       equ 16
DLIST_VSCROLL       equ 32
ANTIC_MODE_4        equ 4

BLANK1              equ $00
BLANK2              equ $10
BLANK7              equ $60
BLANK8              equ $70
DLI                 equ 128
DLISTJUMP           equ $01
DLISTENDJUMP        equ $41

;##################################################
; hardware registers
;##################################################
HITCLR          equ $D01E 
PORTA           equ $D300
PORTB           equ $D301
IRQEN           equ $D20E
NMI          	equ $FFFA
CHACTL          equ $D401
NMIEN           equ $D40E
NMIRES          equ $D40F
DMACTL          equ $D400
DLISTL          equ $D402
CHBASE          equ $D409
WSYNC           equ $D40A
VCOUNT          equ $D40B
HSCROL          equ $D404
RANDOM          equ $D20A
COLPM0          equ $D012
COLPM1          equ $D013
COLPM2          equ $D014
COLPM3          equ $D015
COLPF0          equ $D016
COLPF1          equ $D017
COLPF2          equ $D018
COLPF3          equ $D019
COLBK           equ $D01A
HPOSP0          equ $D000
HPOSP1          equ $D001
HPOSP2          equ $D002
HPOSP3          equ $D003
HPOSM0          equ $D004
HPOSM1          equ $D005
HPOSM2          equ $D006
HPOSM3          equ $D007
SIZEP0          equ $D008
SIZEP1          equ $D009
SIZEP2          equ $D00A
SIZEP3          equ $D00B
SIZEM           equ $D00C
TRIG0           equ $D010
GRACTL          equ $D01D
PMBASE          equ $D407
PRIOR           equ $D01B
CONSOL          equ $D01F
BANK_BASE       equ $D500


