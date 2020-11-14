#preparo file di output switching activity
vcd file ../vcd/IIR_filter_order2_syn.vcd
vcd add /testbench/UUT/*

#preparo file di output report power
power add *

add wave *
run 2200 ns

#salvo report power
power report -file ./output_report/reportEsw_modelsim.txt
