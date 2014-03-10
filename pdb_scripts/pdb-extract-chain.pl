#!/usr/bin/perl -w

# Written by Karolis Uziela in 2012

use strict;

my $input_file = $ARGV[0];
my $chain2extract = $ARGV[1];

#print "$input_file\n";
#print "$chain2extract\n";

open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";

while (my $line=<IN_FILE>) {
    #chomp $line;
    if (($line =~ /^ATOM/) || ($line =~ /^HETATM/)) {
        my $chain=substr($line,21,1);
        if ($chain eq $chain2extract) {
            print $line;
        }
    }   #else {
        #    print $line;
        #}
    last if($line =~ /^ENDMDL/);
}
print "\n";

close(IN_FILE) or die "Error occured closing input file: $!";

