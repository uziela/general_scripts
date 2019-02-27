#!/usr/bin/perl -w

# Written by Karolis Uziela in 2019


use strict;
use Getopt::Long;

my $usage = "
Usage:
$0 [Parameters]

Parameters:

-i <filename>  Name of input file

-o <filename>  Name of output file

-h             Short description

";

# input files/directories   
my $INPUT_FILE;

# output files/directories
my $OUTPUT_FILE;

# constants
# N/A

# global variables
# N/A


################ read in parameters #####################

if ($#ARGV == -1) {
    die $usage;
}

print STDERR "$0 has started with parameters: @ARGV\n";

my $opt_return = GetOptions(
               'in|i=s'   => \$INPUT_FILE,
               'out|o=s'  => \$OUTPUT_FILE,
               'help|h'   => sub { print $usage; exit( 0 ); }
);

if (! $opt_return) {
    die "Program terminated because of unkown options.";
}

if ($#ARGV >=0) {
    die "
Program terminated because of unkown options.
Unknown option:
@ARGV
";
}

###################### main script ######################

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
    }

    close(IN_FILE) or die "Error occured closing input file: $!";
}

sub write_file {
    my $output_file = $_[0];
    open(OUT_FILE,">$output_file") or die "Error occured opening output file: '$output_file': $!";
    
    close(OUT_FILE) or die "Error occured closing output file: $!";
}
