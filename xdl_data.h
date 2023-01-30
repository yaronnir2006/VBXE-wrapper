; XDL data 
;-----------------------------------------
; XDL definition
XDL_DATA 
    ; top part of screen, overscan lines
    ; no overlay and repeat for 23 lines
    dta XDLC_OVOFF | XDLC_RPTL ; first byte 
    dta $0                     ; second byte, not used here
    dta $17                    ; repeat data $17=23

; main part of the screen the
; graphics mode, repeat for 192 scanlines 
; setting overlay address $000000 and step
    dta XDLC_GMON | XDLC_MAPOFF | XDLC_RPTL | XDLC_OVADR ; first byte
    dta XDLC_ATT  | XDLC_END   ; second byte
    dta $C0         ; repeat $C0=192 
    dta $00         ; overlay address $000000
    dta $00
    dta $00 
    dta $40        ; step $140=320 pixels per line
    dta $01
    dta XDLC_ATT_OV_WIDTH_NORMAL    ; NORMAL = 320 pixel
    dta XDLC_ATT_MAIN_PRIORITY_OVERLAY_ALL

XDL_DATA_LEN equ *-XDL_DATA