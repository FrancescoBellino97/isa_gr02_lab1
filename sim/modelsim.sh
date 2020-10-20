ù#!/bin/bash

source /software/scripts/init_msim6.2g

if [ -e work ]
then
rm -r work
rm transcript
rm vsim.wlf
fi

vlib work

vcom -93 -work ./work ../src/*.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/*.v

vsim  work.testbench


