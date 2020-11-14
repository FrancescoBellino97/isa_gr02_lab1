rm -f ../saif/IIR_filter_order2_syn.saif
source /software/scripts/init_synopsys_64.18
vcd2saif -input ../vcd/IIR_filter_order2_syn.vcd -output ../saif/IIR_filter_order2_syn.saif
