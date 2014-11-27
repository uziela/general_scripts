#!/usr/bin/perl
# Takes a pdb file and returns the sequence in 1 letter code

if ($#ARGV != 0) {
    die "
Usage:

$0 <input-file> <chainid>

  <input-file> - input pdb file
\n";
}

my $input_file = $ARGV[0];
#my $chain2extract = $ARGV[1];
    


my %table=('ALA', 'A',
    'ARG', 'R',
    'ASN', 'N',
    'ASP', 'D',
    'CYS', 'C',
    'GLN', 'Q',
    'GLU', 'E',
    'GLY', 'G',
    'HIS', 'H',
    'ILE', 'I',
    'LEU', 'L',
    'LYS', 'K',
    'MET', 'M',
    'PHE', 'F',
    'PRO', 'P',
    'SER', 'S',
    'THR', 'T',
    'TRP', 'W',
    'TYR', 'Y',
    'VAL', 'V',
        'ASX', 'B',
        'GLX', 'Z',
        'XXX', 'A',
        'MSE', 'M',
        'FME', 'M',
        'PCA', 'E',
        '5HP', 'E',
        'SAC', 'S',
        'CCS', 'C');

open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";
    
$old_resnum="whatever";
while(<IN_FILE>)
{
    if(/^ATOM/)
    {
    my $atomno=substr($_, 7, 4);
    my $atomtype=substr($_, 12, 4);
    my $resnum=substr($_,21,6);
    #my $chain=substr($_,21,1);
    $resnum=~s/\s+//g;
    #print "$resnum $old_resnum $atomtype\n";
    #print $atomtype ;
    if($atomtype=~/CA/ && $old_resnum ne $resnum)
    {
        $res=substr($_,17, 3);
        print $table{$res};
        #print "$res\n";
        #print "$chain";
        $old_resnum=$resnum;
    }
    }

    last if(/^ENDMDL/);
}
print "\n";

close(IN_FILE) or die "Error occured closing input file: $!";



