#!/usr/bin/perl -w

# Written by Karolis Uziela in 2013

use strict;

my $last_res = "";
my $last_chain = "";
my $cur_resn = 1;

while (my $line=<>) {
    chomp $line;
    if ($line =~ /^ATOM/) {
        my $cur_res = substr($line, 22, 5); # residue number, including the chain ID and insertion code if any
        my $cur_chain = substr($line, 21, 1);
        my $beginning = substr($line, 0, 21);
        my $end = substr($line, 27);
        if ($cur_chain ne $last_chain) {
            $last_chain = $cur_chain;
            $last_res = $cur_res;
            $cur_resn = 1;
        } elsif ($last_res ne $cur_res) {
            $cur_resn += 1;
            $last_res = $cur_res;
        }
        #print "$line\n";
        printf("$beginning$cur_chain%4d $end\n", $cur_resn);
        #print "---------\n";
    }
}


