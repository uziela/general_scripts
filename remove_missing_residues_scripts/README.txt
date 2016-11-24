Author: Karolis Uziela, karolis.uziela@scilifelab.se, 2016

Description:
This script package removes residues from the models that are not present in the native structure

Requirements:
Biopython
EMBOSS package

Install:
Set path to EMBOSS/needle program in remove_missing_pipeline.sh

Usage:
./remove_missing_pipeline.sh <input-pdb-model> <native-pdb> <output-pdb-model-without-missing-residues>
