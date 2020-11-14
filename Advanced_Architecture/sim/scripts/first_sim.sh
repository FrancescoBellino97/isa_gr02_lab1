#!/bin/bash

source /software/scripts/init_msim6.2g

rm -rf work
rm -f transcript
rm -f vsim.wlf

vlib work

vcom -93 -work ./work ../src/*.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/*.v

vsim work.testbench
