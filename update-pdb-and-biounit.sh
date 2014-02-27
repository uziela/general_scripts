#!/bin/bash

# Written by Karolis Uziela in 2013

echo_both "------------------- stage 1 -------------------"
MYDATE=`date --rfc-3339=date`
mkdir rsync-logs-$MYDATE
rsync -rlpt -v -z -c --delete --port=33444 rsync.wwpdb.org::ftp_data/biounit/coordinates/divided/ rsync_biounit 1>rsync-logs-$MYDATE/biounit.log 2>rsync-logs-$MYDATE/biounit.err
rsync -rlpt -v -z --delete --port=33444 rsync.wwpdb.org::ftp_data/structures/divided/pdb/ rsync_pdb 1>rsync-logs-$MYDATE/pdb.log 2>rsync-logs-$MYDATE/pdb.err

echo_both "------------------- stage 2 -------------------"
cp -r rsync_biounit biounit-$MYDATE
cp -r rsync_pdb pdb-$MYDATE

echo_both "------------------- stage 3 -------------------"
for i in biounit-$MYDATE/* pdb-$MYDATE/* ; do
    count=`ls -1 $i/*.gz 2>/dev/null | wc -l`
    if [ $count != "0" ] ; then
        gunzip $i/*.gz
    fi
done

rm pdb biounit 2>/dev/null
ln -s biounit-$MYDATE biounit
ln -s pdb-$MYDATE pdb


echo_both "------------------- stage 4 -------------------"

rm -r pdb_all biounit_all 2>/dev/null

mkdir biounit_all
for i in biounit-$MYDATE/* ; do
    count=`ls -1 $i/* 2>/dev/null | wc -l`
    if [ $count != "0" ] ; then
        for j in $i/* ; do
            path=`readlink -f $j`
            ln -s $path ./biounit_all
        done
    fi  
done

mkdir pdb_all
for i in pdb-$MYDATE/* ; do
    count=`ls -1 $i/* 2>/dev/null | wc -l`
    if [ $count != "0" ] ; then
        for j in $i/* ; do
            path=`readlink -f $j`
            base=`basename $j`
            pdbbase=`substr $base 4 7`
            ln -s $path ./pdb_all/$pdbbase.pdb
        done
    fi  
done


rm pdb_entry_type.txt pdb_seqres.txt resolu.idx pdb_chain_uniprot.tsv.gz pdb_chain_uniprot.tsv 2>/dev/null
wget ftp://ftp.rcsb.org/pub/pdb/derived_data/pdb_entry_type.txt
wget ftp://ftp.rcsb.org/pub/pdb/derived_data/pdb_seqres.txt
wget ftp://ftp.rcsb.org/pub/pdb/derived_data/index/resolu.idx
wget ftp://ftp.ebi.ac.uk/pub/databases/msd/sifts/flatfiles/tsv/pdb_chain_uniprot.tsv.gz
gunzip pdb_chain_uniprot.tsv.gz
