#!/bin/bash

source /software/scripts/init_msim6.2g

rm -rf work
rm -f transcript
rm -f vsim.wlf
#rm -rf output_report

vlib work

if [ ! -d output_report ]
then
mkdir output_report
fi


vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/*.v
vlog -work ./work ../innovus/IIR_filter_order2.v

vsim -L	/software/dk/nangate45/verilog/msim6.2g -sdftyp /testbench/UUT=../innovus/IIR_filter_order2.sdf work.testbench
