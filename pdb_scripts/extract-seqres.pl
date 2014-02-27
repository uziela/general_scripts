#!/usr/bin/perl -w

# Written by Karolis Uziela in 2013

# Extracts sequences from SEQRES field (for all chains)

use strict;

if ($#ARGV != 0) {
    die "
Usage:

$0 [Parameters]

Parameters:
    <input-file> - input pdb file
\n";
}

# input files/directories   
my $INPUT_FILE = $ARGV[0];


# constants
my @amino_acids_1 = ("A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y","X");
my @amino_acids_3 = ("ALA","CYS","ASP","GLU","PHE","GLY","HIS","ILE","LYS","LEU","MET","ASN","PRO","GLN","ARG","SER","THR","VAL","TRP","TYR","UNK");




# global variables
# N/A

###################### main script ######################

print STDERR "$0 has started with arguments: @ARGV\n";

open(PDBFILE, "$INPUT_FILE") or die "Error occured opening input file '$INPUT_FILE': $!";

my %seq=();

while(<PDBFILE>) {
    chomp;
    # Skip if empty line
    $_ =~ /^\s+$/ && next;
    my @row = split " ", $_;
    if ( $row[0] eq "SEQRES" ){
        #   print;
        shift(@row);
        shift(@row);
        my $chain=shift(@row);
        shift(@row);

        foreach my $three (@row){
            my $one;
            for(my $a = 0; $a < 21; $a++) {
                if($three eq $amino_acids_3[$a]) {
                    $one = $amino_acids_1[$a];
                    last;
                }   
            }   
            #     printf "%s %s \n",$three,$one ;
            if ( ! $one ) { 
                print "Warning: Single letter code for $three not found. Using 'X'...\n"; 
                $one = "X";
            }   
            $seq{$chain}.=$one;
        }
    }   
}

close(PDBFILE) or die "Error occured closing input file: $!";

foreach my $chain (keys %seq){
    print "$seq{$chain}\n";
}


print STDERR "$0 done.\n";

