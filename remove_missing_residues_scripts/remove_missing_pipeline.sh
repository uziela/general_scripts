#!/bin/bash

# Written by Karolis Uziela in 2014

script_name=`basename $0`

if [ $# != 3 ] ; then
    echo "
Usage: 

$script_name [Parameters]

Parameters:
<input-model-file>
<input-native-file>
<output-model-file> 

Output model file will have residues that are missing in the native structure removed

"
    exit 1
fi

i=$1
native=$2
missing_removed=$3

needle_bin="/proj/wallner/users/x_karuz/software/EMBOSS-6.6.0-kappa/emboss/needle"

echo "$script_name started with parameters: $*"

base=`basename $i`
run_dir=`dirname $0`

model_seq=`$run_dir/aa321CA-all-chains.pl $i`
echo ">$base" > $i.fasta.$$.temp
echo $model_seq >> $i.fasta.$$.temp

native_seq=`$run_dir/aa321CA-all-chains.pl $native`
echo ">$base-native" > $i.native.fasta.$$.temp
echo $native_seq >> $i.native.fasta.$$.temp

$needle_bin -sprotein -aseq $i.fasta.$$.temp -bseq $i.native.fasta.$$.temp -gapopen 1 -gapextend 0.5 -outfile $i.model-native.needle.$$.temp

$run_dir/remove-missing-res-from-pdb.py $i $i.model-native.needle.$$.temp $missing_removed

missing_removed_seq=`$run_dir/aa321CA-all-chains.pl $missing_removed`
echo ">$base-missing_removed" > $missing_removed.fasta.$$.temp
echo $missing_removed_seq >> $missing_removed.fasta.$$.temp

# Validation

$needle_bin -sprotein -aseq $missing_removed.fasta.$$.temp -bseq $i.native.fasta.$$.temp -gapopen 1 -gapextend 0.5 -outfile $missing_removed-native.needle.$$.temp

validate=`$run_dir/remove-missing-res-from-pdb-validate.py $i.model-native.needle.$$.temp $missing_removed-native.needle.$$.temp`
if [ "$validate" == "OK" ] ; then
    #echo "OK"
    rm $missing_removed-native.needle.$$.temp $i.model-native.needle.$$.temp $i.native.fasta.$$.temp $i.fasta.$$.temp $missing_removed.fasta.$$.temp
else
    echo $validate
fi


echo "$script_name done."
