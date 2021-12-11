; homex.g
; called to home the X axis
;
; generated by RepRapFirmware Configuration Tool v2.1.4 on Sat Jan 04 2020 09:46:45 GMT+1000 (Australian Eastern Standard Time)
M400 ; wait for moves to finish
;lower speeds for homing
M566 X200.00 Y200.00 Z10.00 E800.00                          ; set maximum instantaneous speed changes (mm/min)
M203 X1200.00 Y1200.00 Z600.00 E6000.00                  ; set maximum speeds (mm/min)
M201 X400.00 Y400.00 Z60.00 E120.00                        ; set accelerations (mm/s^2)

;M913 X80 Y80 Z80 ; set X Y Z motors to 50% of their normal current
G91               ; relative positioning
G1 H2 Z5 F120    ; lift Z relative to current position
G1 H1 X-205 F1200 ; move quickly to X axis endstop and stop there (first pass)
if result != 0
	abort "Error duing fast homing X axis - process cancelled"
G1 H2 X5 F1200    ; go back a few mm
G1 H1 X-205 F360  ; move slowly to X axis endstop once more (second pass)
if result != 0
	abort "Error duing slow homing X axis - process cancelled"
G1 H2 Z-5 F120   ; lower Z again
G90               ; absolute positioning
M400 ; wait for moves to finish
M913 X100 Y100 Z100 ; set X Y Z motors to 100% of their normal current
M98 P"0:/sys/set_max_speeds.g" ; reset max speeds

