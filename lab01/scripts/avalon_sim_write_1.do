vlib work

vcom -work work ../lcd_interface.vhd
vcom -work work ../tb/tb_lcd_interface.vhd

vsim -work work tb_lcd_interface

add wave -position end sim:/tb_lcd_interface/*
add wave -position end sim:/tb_lcd_interface/DUT/*

force clk 0 0, 1 10ns -repeat 20ns
force nreset 0 1, 1 100ns

force address xxx 0, 001 205ns, xxx 225ns, 010 405ns, xxx 425ns
force writedata 16#XX 0, 16#2A 205ns, 16#XX 225ns, 16#CC 405ns, 16#XX 425ns
force write 0 0, 1 205ns, 0 225ns, 1 405ns, 0 425ns
force chipselect 0 0, 1 208ns, 0 228ns, 1 405ns, 0 425ns

run 600ns
