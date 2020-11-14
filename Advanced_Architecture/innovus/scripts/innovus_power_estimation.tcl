#design import
encMessage warning 0
encMessage debug 0
encMessage info 0
restoreDesign /home/isa02/Desktop/test/innovus/design/IIR_filter_order2.enc.dat IIR_filter_order2
setDrawView fplan
encMessage warning 1
encMessage debug 0
encMessage info 1


#extract parasitic RC
reset_parasitics
extractRC
rcOut -setload output/parasitic/IIR_filter_order2.setload -rc_corner my_rc
rcOut -setres output/parasitic/IIR_filter_order2.setres -rc_corner my_rc
rcOut -spf output/parasitic/IIR_filter_order2.spf -rc_corner my_rc
rcOut -spef output/parasitic/IIR_filter_order2.spef -rc_corner my_rc


#power analysis
set_power_analysis_mode -reset
set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true

set_power_output_dir -reset
set_power_output_dir ./
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
read_activity_file -format VCD -scope /testbench/UUT -start {} -end {} -block {} ../vcd/IIR_filter_order2_innovus.vcd
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile .//IIR_filter_order2.rpt


#save power report
report_power -outfile output/report/innovus_power_report.txt -sort { total }

