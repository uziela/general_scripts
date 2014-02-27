#!/usr/bin/perl -w

# 2010 (C) Karolis Uziela, karolis.uziela@gmail.com
# The script is meant to be required by other scripts
# 
# The function parses some type of score
#
# Usage:
# parse_score(input-file, type)
# type can be -tm, -proq2 or others (see below)

sub parse_score {
    my $INPUT_FILE = $_[0];
    my $TYPE = $_[1];
    my $score = "";
    
    open(IN_FILE, "$INPUT_FILE") or die "Error occured opening input file '$INPUT_FILE': $!";
    while (my $line=<IN_FILE>) {
        chomp $line;
        if ($TYPE eq "-tm") {
            if ($line =~ m/^TM-score\s+=\s+(-?\d+\.\d+)\s+/) {
                $score = $1;
            }
        } elsif ($TYPE eq "-proq2") {
            if ($line =~ m/^Global quality:\s+(-?\d+\.\d+)\s+/) {
                $score = $1;
            }
        } elsif ($TYPE eq "-gdt") {
            if ($line =~ m/^GDT-TS-score=\s+(-?\d+\.\d+)\s+/) {
                $score = $1;
            }
        } elsif ($TYPE eq "-corr") {
            if ($line =~ m/^Correlation:\s+(-?\d+\.\d+)$/) {
                $score = $1;
            } 
        } elsif ($TYPE eq "-res") {
            if ($line =~ m/RESOLUTION\.\s+(-?\d+\.\d+)\s+ANGSTROMS\./) {
                $score = $1;
            } 
        } elsif ($TYPE eq "-rmsd") {
            if ($line =~ m/^RMSD of  the common residues=\s+(-?\d+\.\d+)$/) {
                $score = $1;
            } 
        } elsif ($TYPE eq "-length") {
            if ($line =~ m/Length=\s+(\d+)\s+/) {
                $score = $1;
            } 
        }
    }
    close(IN_FILE) or die "Error occured closing input file: $!";
    
    if ($score eq "") {
        print "WARNING:Score not found in a file '$INPUT_FILE'\n";
    }
    return $score;
}

1;

