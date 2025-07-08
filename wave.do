onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk -radix binary /top_tb/uut/clk
add wave -noupdate -label instr -radix hexadecimal /top_tb/uut/cpu_instance/decode_instance/instr
add wave -noupdate -label pc -radix decimal /top_tb/uut/cpu_instance/pc/current
add wave -noupdate -label next_pc -radix unsigned /top_tb/uut/cpu_instance/pc/next
add wave -noupdate -label x10 -radix decimal {/top_tb/uut/cpu_instance/reg_file_instance/regs[10]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {218400 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {195400 ps} {305600 ps}
