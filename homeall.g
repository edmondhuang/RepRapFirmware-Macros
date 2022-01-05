; homeall.g
; called to home all axes
;
; generated by RepRapFirmware Configuration Tool v2.1.4 on Sat Jan 04 2020 09:46:45 GMT+1000 (Australian Eastern Standard Time)
M98 P"0:/sys/checkATX.g"
set global.Cancelled = false
;lower speeds for homing
M566 X200.00 Y200.00 Z10.00 E800.00                          ; set maximum instantaneous speed changes (mm/min)
M203 X1200.00 Y1200.00 Z600.00 E6000.00                  ; set maximum speeds (mm/min)
M201 X400.00 Y400.00 Z60.00 E120.00                        ; set accelerations (mm/s^2)

;G91                     ; relative positioning
;G1 H2 Z6 F6000          ; lift Z relative to current position

M564 S0 H0 ; allow movement before homing
G91
G1 Z15 ; raise head 15mm
G90
M564 S1 H1 ; dissallow movement without homing


M400 ; wait for all moves to finish
;M913 Z80 ; set X Y Z motors to 80% of their normal current

M561 ; clear any bed transform
;M290 R0 S0 ; clear babystepping

;check BL Touch
if sensors.probes[0].value[0]=1000 ; if probe is in error state
	echo "Probe in error state- resetting"
	M280 P0 S160 ; reset BL Touch
	G4 S0.5
if state.gpOut[0].pwm=0.03
	echo "Probe ia already deployed - retracting"
	M280 P0 S80 ; retract BLTouch
	G4 S0.5

if sensors.endstops[2].triggered
	echo "Probe ia already triggered - resetting"
	M280 P0 S160 ; reset BL Touch
	G4 S0.5

G1 H1 X-205 Y-205 F1800 ; move quickly to X and Y axis endstops and stop there (first pass)
if result != 0
	abort "Print cancelled due error during fast homing"
G1 H2 X5 Y5 F1000       ; go back a few mm
G1 H1 X-205 Y-205 F360  ; move slowly to X and Y axis endstops once more (second pass)
if result != 0
	abort "Print cancelled due to error during slow homing"

G90                     ; absolute positioning
; variabes set in Config.g
G1 X{global.Bed_Center_X - sensors.probes[0].offsets[0] } Y{global.Bed_Center_Y - sensors.probes[0].offsets[1]} F12000
M400 ; wait for moves to finish
G30               ; home Z by probing the bed
if result !=0
	abort "Print cancelled due to probe error"

M400 ; wait for all moves to finish
M913 X100 Y100 Z100 ; set X Y Z motors to 100% of their normal current

;reset speeds
M98 P"0:/sys/set_max_speeds.g"

; Uncomment the following lines to lift Z after probing
;G91                    ; relative positioning
;G1 S2 Z5 F100          ; lift Z relative to current position
;G90                    ; absolute positioning


