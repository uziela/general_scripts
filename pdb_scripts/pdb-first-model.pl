#!/usr/bin/perl -w

# Written by Karolis Uziela in 2012

use strict;

while (my $line=<>) {
    #chomp $line;
    print $line;
    last if($line =~ /^ENDMDL/);
}

