#!/usr/bin/perl -w

# 2010 (C) Karolis Uziela, karolis.uziela@gmail.com
# The script is meant to be required by other scripts
#
# The function reads all filenames or subdirectory names in a directory
#
# Usage:
# read_dir(dir_name, option_string)
# option_string can be:
# 1) -all - to list all files and subdirectories (except implied subdirectories . and ..)
# 2) -dirs - to list all subdirectories
# 3) -files - to list all files
# 4) file_extension - to list all files with this extension (for example ".txt")

use strict;

sub read_dir {
    my $OPT = $_[1];
    opendir DIR1, $_[0] or die "Failed to open input directory '$_[0]': $!";
    my @dir = readdir DIR1;
    close DIR1;
    my @dirf;
    foreach my $i (@dir) {
        if ($OPT eq "-all") {
            push(@dirf, $i) if (($i ne ".") && ($i ne ".."));
        }
        elsif ($OPT eq "-dirs") {
            push(@dirf, $i) if ((-d "$_[0]/$i") && ($i ne ".") && ($i ne ".."));
        }
        elsif ($OPT eq "-files") {
            push(@dirf, $i) if (!(-d "$_[0]/$i"));
        }
        else {                                                                                                                      # in this case $OPT specifies file extension
            push(@dirf, $i) if (!(-d "$_[0]/$i") && ($i =~ m/$OPT$/));
        }
    }
    return @dirf;
}


1;
