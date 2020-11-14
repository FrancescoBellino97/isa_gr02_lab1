#leggo la netlist del circuito
read_verilog -netlist ../netlist/IIR_filter_order2.v

#leggo file della switching activity
read_saif -input ../saif/IIR_filter_order2_syn.saif -instance testbench/UUT -unit ns -scale 1

create_clock -name MY_CLK

#salvo il report power
report_power > ./output_report/reportEsw_synopsys.txt

quit
