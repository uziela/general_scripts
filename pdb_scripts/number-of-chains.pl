#!/usr/bin/perl

# Written by Karolis Uziela in 2012

if ($#ARGV != 0) {
    die "
Usage:

$0 <input-file>

  <input-file> - input pdb file
\n";
}

my $input_file = $ARGV[0];

open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";

my $chain_count = 0;

$old_chain="whatever";
while(<IN_FILE>) {
    if(/^ATOM/) {
        my $chain=substr($_,21,1);
        if ($old_chain ne $chain) {
            $chain_count++;
            $old_chain = $chain;
        }
    }

    last if(/^ENDMDL/);
}
print "$chain_count\n";

close(IN_FILE) or die "Error occured closing input file: $!";



