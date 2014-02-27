#!/usr/bin/perl -w

##
## 2008 (C) Mindaugas Margelevicius
## Institute of Biotechnology
## Vilnius, Lithuania
##

use strict;
use FindBin;
use lib "$FindBin::Bin";
use File::Basename;
use Getopt::Long;

my  $MYPROGNAME = basename( $0, ( '.pl' ));
my  $WIDTH = 60;

my  $usage = <<EOIN;

Output amino acid sequence encapsulated in PDB file.
2008(C)Mindaugas Margelevicius,IBT,Vilnius


Usage:
$0 <Parameters>

Parameters:

-i <filename>
             Name of input pdb file.
     default=<stdin>

-o <filename>
             Name of file to write output sequence to.
     default=<stdout>

-w <width>   Wrap output sequence in fragments of the given
             width.
     default=$WIDTH

-c <chain_id>
             Identifier of chain to extract sequence from.
             By default all chains are processed.
     optional

-p <header>  Prepend first header line to output.
     optional

-h           Short description

EOIN

my  $INPUT;
my  $OUTPUT;
my  $CHAIN;
my  $HEADER;

my  $result = GetOptions(
               'in|i=s'   => \$INPUT,
               'out|o=s'  => \$OUTPUT,
               'wid|w=i'  => \$WIDTH,
               'chn|c=s'  => \$CHAIN,
               'pre|p=s'  => \$HEADER,
               'help|h'   => sub { print $usage; exit( 0 ); }
);

die "ERROR: File $INPUT not found." if( $INPUT && !-f $INPUT );
die "ERROR: Wrong width specified." if( $WIDTH <= 0 || 99999 < $WIDTH );
die "ERROR: Wrong chain identifier." if( $CHAIN && 1 < length( $CHAIN ));

## ===================================================================

my  %RESDS = (
    'ALA' => 'A',     'ARG' => 'R',     'ASN' => 'N',     'ASP' => 'D',
    'CYS' => 'C',     'GLU' => 'E',     'GLN' => 'Q',     'GLY' => 'G',
    'HIS' => 'H',     'ILE' => 'I',     'LEU' => 'L',     'LYS' => 'K',
    'MET' => 'M',     'PHE' => 'F',     'PRO' => 'P',     'SER' => 'S',
    'THR' => 'T',     'TRP' => 'W',     'TYR' => 'Y',     'VAL' => 'V',
);

## ===================================================================

exit( 1 ) unless PDBSequence( $WIDTH, $INPUT, $OUTPUT, $CHAIN );
exit( 0 );

## ===================================================================
## renumerate input pdb structure and write it to given output stream
##

sub PDBSequence
{
    my  $width = shift;
    my  $inputname = shift;
    my  $outputname = shift;
    my  $chain = shift;

    my  @pdblines;
    my  $sequence;

    return 0 unless ReadPDB( \@pdblines, $inputname );
    return 0 unless GetPDBSequence( \@pdblines, \$sequence, $chain );
    return 0 unless WrapFasta( \$sequence, $outputname, $width, $HEADER );
    return 1;
}

## -------------------------------------------------------------------
## extract one-letter aa sequence from pdb data
##

sub GetPDBSequence
{
    my  $refpdb = shift;  ## reference tp pdb data
    my  $sequen = shift;  ## reference to sequence to be constructed
    my  $chain = shift;   ## chain id

    my  $reshash = \%RESDS;

    my  $resname = '';
    my  $resnum = '';
    my  $reshet = '';
    my  $nrec = 0;

    $$sequen = '';

    while( NextRes( $refpdb, $chain, \$nrec, \$resname, \$resnum, \$reshet )) {
        if( $reshet || !exists $reshash->{$resname} ) {
            $$sequen .= 'X';
            next;
        }
        $$sequen .= $reshash->{$resname};
    }
    return 1;
}

## -------------------------------------------------------------------
## scroll to next residue in pdb file
##

sub NextRes
{
    my  $refpdb = shift;  ## reference tp pdb data
    my  $chain = shift;   ## chain id
    my  $nnn = shift;     ## reference to current record
    my  $resname = shift; ## reference to next residue
    my  $resnum = shift;  ## reference to next residue's number
    my  $reshet = shift;  ## reference to flag of whether next residue is HETATM

    my  $curchain;
    my  $prevnum = $$resnum;
    my  $first = $$nnn == 0;
    my  $nechain = 0;
    my  $atom = 0;


    for( ; $$nnn <= $#$refpdb &&
       ( !$$resnum || ( $$resnum eq $prevnum )); $$nnn++ )
    {
        next if $refpdb->[$$nnn] =~ /^(?:SIGATM|ANISOU|SIGUIJ)/;
        $atom = $refpdb->[$$nnn] =~ /^(?:ATOM|HETATM)/;
        next unless $atom;
        ## 18-20 Res name, 23-26 Res No., 27 Ins. code
        ##
        $$resname = substr( $refpdb->[$$nnn], 17, 3 );
        $curchain = substr( $refpdb->[$$nnn], 21, 1 );
        $$resnum = substr( $refpdb->[$$nnn], 22, 5 );
        $$reshet = 0;
        $$reshet = 1 if $refpdb->[$$nnn] =~ /^HETATM/;
        $nechain = $chain &&( $chain ne $curchain );
        last if $nechain;
    }
    return 0 if( $#$refpdb < $$nnn || $nechain );
    return 1;
}

## -------------------------------------------------------------------
## read PDB file into list given by reference
##

sub ReadPDB {
    my  $reflines = shift;
    my  $filename = shift;
    my  $refile = \*STDIN;

    if( $filename ) {
        unless( open( PFD, $filename )) {
            printf( STDERR "ERROR: ReadPDB: Cannot open file %s\n", $filename );
            return 0;
        }
        $refile = \*PFD;
    }

    while( <$refile> ) {
        chomp;
        push @{$reflines}, $_;
    }

    if( $filename ) {
        close( $refile );
    }
    return 1;
}

## -------------------------------------------------------------------
## write PDB information vectors to file
##

sub WritePDB {
    my  $reflines = shift;
    my  $filename = shift;
    my  $refile = \*STDOUT;

    if( $filename ) {
        unless( open( PFD, ">$filename" )) {
            printf( STDERR "ERROR: WritePDB: Cannot open file $filename for writing.\n" );
            return 0;
        }
        $refile = \*PFD;
    }

    print( $refile "$_\n" ) foreach( @{$reflines} );

    if( $filename ) {
        close( $refile );
    }
    return 1;
}

## -------------------------------------------------------------------
## wrap Fasta sequence and write it to file
##

sub WrapFasta {
    my  $reffasta = shift;  ## reference to sequence
    my  $filename = shift;  ## name of file
    my  $width = shift;     ## width of sequence per line
    my  $header = shift;    ## header line
    my  $refile = \*STDOUT;

    if( $filename ) {
        unless( open( PFD, ">$filename" )) {
            printf( STDERR "ERROR: WrapFasta: Cannot open file %s for writing.\n", $filename );
            return 0;
        }
        $refile = \*PFD;
    }

    if( $header ) {
        chomp( $header );
        printf( $refile "%s\n", $header );
    }

    for( my $n = 0; $n < length( $$reffasta ); $n += $width ) {
        printf( $refile "%s\n", substr( $$reffasta, $n, $width ));
    }

    close( $refile ) if( $filename );
    return 1;
}

##<<>>
