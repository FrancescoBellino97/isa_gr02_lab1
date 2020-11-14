analyze -f vhdl -lib WORK ../src/OperationOfMultiplier.vhd
analyze -f vhdl -lib WORK ../src/OperationOfSum.vhd
analyze -f vhdl -lib WORK ../src/register_data.vhd
analyze -f vhdl -lib WORK ../src/regIn_out.vhd
analyze -f vhdl -lib WORK ../src/shiftLeft.vhd
analyze	-f vhdl	-lib WORK ../src/shiftRight.vhd
analyze -f vhdl -lib WORK ../src/controlUnit.vhd
analyze -f vhdl -lib WORK ../src/datapath_IIR.vhd
analyze -f vhdl -lib WORK ../src/IIR_filter_order2.vhd

set power_preserve_rtl_hier_names true
elaborate IIR_filter_order2 -arch Structural -lib WORK > ./output_report/elaborate.txt
uniquify
link

create_clock -name MY_CLK -period 11.20 Clk
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] Clk]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

compile

report_timing > ./output_report/reportTiming.txt
report_area > ./output_report/reportArea.txt

ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/IIR_filter_order2.sdf
write -f verilog -hierarchy -output ../netlist/IIR_filter_order2.v
write_sdc ../netlist/IIR_filter_order2.sdc

quit
