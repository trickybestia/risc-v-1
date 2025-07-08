onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk -radix binary /top_tb/uut/clk
add wave -noupdate -label instr -radix hexadecimal /top_tb/uut/cpu_instance/decode_instance/instr
add wave -noupdate -label pc -radix decimal /top_tb/uut/cpu_instance/pc/current
add wave -noupdate -label next_pc -radix unsigned /top_tb/uut/cpu_instance/pc/next
add wave -noupdate /top_tb/uut/instr_mem_instance/addr
add wave -noupdate -radix decimal /top_tb/uut/cpu_instance/jal_pc_adder/b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10400 ps} 0}
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
WaveRestoreZoom {0 ps} {109100 ps}
