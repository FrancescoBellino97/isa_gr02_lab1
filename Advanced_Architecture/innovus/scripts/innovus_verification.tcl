#parasitics extraction
reset_parasitics
extractRC
rcOut -setload output/parasitic/IIR_filter_order2.setload -rc_corner my_rc
rcOut -setres output/parasitic/IIR_filter_order2.setres -rc_corner my_rc
rcOut -spf output/parasitic/IIR_filter_order2.spf -rc_corner my_rc
rcOut -spef output/parasitic/IIR_filter_order2.spef -rc_corner my_rc

#timing analysis
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix IIR_filter_order2_postRoute -outDir timingReports

redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix IIR_filter_order2_postRoute -outDir timingReports


#design analysis and verification
verifyConnectivity -type all -error 1000 -warning 50 -report ./output/verification/verify_connectivity.txt

setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -mergedMGridCheck true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000
verifyGeometry -report ./output/verification/verify_geometry.txt
setVerifyGeometryMode -area { 0 0 0 0 }

reportGateCount -level 5 -limit 100 -outfile output/gateCount/IIR_filter_order2.gateCount

saveNetlist output/netlist/IIR_filter_order2_end.v

all_hold_analysis_views
all_setup_analysis_views
write_sdf -ideal_clock_network output/delay/IIR_filter_order2.sdf

