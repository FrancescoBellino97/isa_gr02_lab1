#!/bin/bash

#rimuovo cartelle
#rm -rf output_report
rm -rf work
rm -f command.log
rm -f default.svf

#controllo che ci sia il file per la sintesi
if ! [ -e .synopsys_dc.setup ]
	then
	echo "File \".synopsys_dc.setup\" non trovato"
	exit 0
fi

#inizializzo ambiente synopsys
source /software/scripts/init_synopsys_64.18

#creo cartelle di output e di lavoro

if [ ! -d output_report ]
then
mkdir output_report
fi

mkdir work

#faccio partire synopsys in modalità shell
dc_shell-xg-t



