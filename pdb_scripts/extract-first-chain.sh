#!/bin/bash

# Written by Karolis Uziela in 2014

script_name=`basename $0`

if [ $# != 1 ] ; then
    echo "
Usage: 

$script_name [Parameters]

Parameters:
<input-pdb>

"
    exit 1
fi

input_file=$1

script_dir=`dirname $0`

chain=`$script_dir/print_pdb_chain_ids.pl $input_file | cut -f 1 -d ' '`

if [ "$chain" == "" ] ; then
    chain=" "
fi

$script_dir/aa321CA-chain.pl $input_file "$chain"
