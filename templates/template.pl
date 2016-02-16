#!/usr/bin/perl -w

# Written by Karolis Uziela in 2016


use strict;

if ($#ARGV != 1) {
    die "
Usage:

$0 [Parameters]

Parameters:
    <input-file> - input file
    <output-file> - output file
\n";
}

# input files/directories   
my $INPUT_FILE = $ARGV[0];

# output files/directories
my $OUTPUT_FILE = $ARGV[1];

# constants
# N/A

# global variables
# N/A

###################### main script ######################

print STDERR "$0 has started with arguments: @ARGV\n";


print STDERR "$0 done.\n";

###################### subroutines ######################

sub read_file {
    my $input_file = $_[0];
    open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";

    #my @file = <IN_FILE>;
    #for (my $i = 0; $i <= $#file; $i++) {
    #}

    while (my $line=<IN_FILE>) {
        chomp $line;
        if ($line =~ //) {
            print "$line\n";
        }
    }

    close(IN_FILE) or die "Error occured closing input file: $!";
}

sub write_file {
    my $output_file = $_[0];
    open(OUT_FILE,">$output_file") or die "Error occured opening output file: '$output_file': $!";
    
    close(OUT_FILE) or die "Error occured closing output file: $!";
}
