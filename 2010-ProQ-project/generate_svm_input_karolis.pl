#!/usr/bin/perl -w

# 2011 (C) Karolis Uziela, karolis.uziela@sbc.su.se
# Arne Elofsson group
# Stockholm University
# Stockholm, Sweden

# Script description:
# N/A


use strict;
use Getopt::Long;
use File::Basename;

require './scripts/parse-score.pl';

my $usage = "
Usage:
$0 <Parameters>

Parameters:

-in <filename>   Name of input file (.pdb file)

-out <dirname>   Name of the output directory. A subdirectory will be created which will have name comprised of script parameters

-sscore <value>  Use average of local S-scores as a target function (requires .S.<value> file)

-ssum <value>    Use sum of local S-scores as a target function (requires .S.<value> file)

-rmsd            Use RMSD instead of S-score as a target function (requires .TM file)

-length          Include protein length (requires .ss2 or .stride file. For simplicity of coding, the length is calculated from one of these files)

-atom            Include ATOM-ATOM contacts (requires ProQres binary, .pdb, .rsa, .stride, .ss2 and .psi files)

-res             Include RES-RES contacts (requires ProQres binary, .pdb, .rsa, .stride, .ss2 and .psi files)

-surf            Include SURF25, SURF50, SURF75 data (requires ProQres binary, .pdb, .rsa, .stride, .ss2 and .psi files)

-secondary       Compare secondary structure agreement (requires .ss2 and .stride files)

-exposed         Compare exposed residue agreement (requires .acc and .rsa files)

-fatness         Include fatness (requires fatness binary)

-help            Short description

NOTE: You have to specify one target function (Sscore, Ssum or RMSD parameter).

";

# input files/directories   
my $INPUT_FILE;

# output files/directories
my $OUTPUT_DIR;
my $SUBDIR;

# constants
my $SSCORE;
my $SSUM;
my $LENGTH;
my $RMSD;
my $ATOM;
my $RES;
my $SURF;
my $SECONDARY;
my $EXPOSED;
my $FATNESS;
my $PROQ_RES_BIN = "./scripts/ProQres64";
my $FATNESS_BIN = "./scripts/fatness";

# global variables
my @data = ();      # svm data array
my @index = ();     # svm index array
my $index = 1;      # the current index
my $target_score;


################ read in parameters #####################

if ($#ARGV == -1) {
    die $usage;
}

print "$0 has started with parameters: @ARGV\n";

$SUBDIR = option_string(@ARGV);

my $opt_return = GetOptions(
               'in|i=s'   => \$INPUT_FILE,
               'out|o=s'   => \$OUTPUT_DIR,
               'sscore=f' => \$SSCORE,
               'ssum=f' => \$SSUM,
               'rmsd!' => \$RMSD,
               'length' => \$LENGTH,
               'atom!' => \$ATOM,
               'res!' => \$RES,
               'surf!' => \$SURF,
               'secondary!'  => \$SECONDARY,
               'exposed!' => \$EXPOSED,
               'fatness!' => \$FATNESS,              
               'help|h'   => sub { print $usage; exit( 0 ); }
);

if (! $opt_return) {
    die "Program terminated because of unkown options.";
}

if ($#ARGV >=0) {
    die "
Program terminated because of unkown options.
Unknown options:
@ARGV
";
}

if ( ! $INPUT_FILE || ! -f $INPUT_FILE) {
    die "ERROR: input file is not defined or does not exist!\n";
}

if ( ! $OUTPUT_DIR || ! -d $OUTPUT_DIR) {
    die "ERROR: output directory is not defined or does not exist!";
}

if ( ! $SSCORE && ! $SSUM && ! $RMSD) {
    die "ERROR: you have to specify one target function!";
}

if ( $SSCORE && $SSUM || $SSCORE && $RMSD || $SSUM && $RMSD) {
    die "ERROR: you have to specify one target function!";
}

###################### main script ######################

my @proq_res_arr;

if ($ATOM || $RES || $SURF) {
    my $proq_res_out = `$PROQ_RES_BIN -pdb $INPUT_FILE -surf $INPUT_FILE.rsa -stride $INPUT_FILE.stride -psipred $INPUT_FILE.ss2 -prof $INPUT_FILE.psi -output_input -ac 4 -rc 6 -w 10001`;
    @proq_res_arr = split(/\n/, $proq_res_out); 
    #print "$proq_res_out\n";
    if ($ATOM) {
        parse_proqres("ATOM");
    }

    if ($RES) {
        parse_proqres("RES");
    }

    if ($SURF) {
        parse_proqres("SURF25");
        parse_proqres("SURF50");
        parse_proqres("SURF75");
        parse_proqres("SURF100");
    }
}

if ($SECONDARY) {
    my $seq = "";
    my $seq2 = "";
    my $ss_pred = "";
    my $stride_pred = "";

    ($seq,$ss_pred) = read_in_psipred2("$INPUT_FILE.ss2");
    ($seq2,$stride_pred) = read_in_stride("$INPUT_FILE.stride");

    if ($seq ne $seq2) {
        die "ERROR: sequences in .ss2 and .stride do not match";
    }

    compare_secondary($ss_pred, $stride_pred);

    #debug();
}

if ($LENGTH) {
    my $seq = "";
    my $ss = "";
    my $len = 0;
    if ( -f "$INPUT_FILE.ss2") {
        ($seq,$ss) = read_in_psipred2("$INPUT_FILE.ss2");
        $len = length($seq);
    } elsif ( -f "$INPUT_FILE.stride") {
        ($seq,$ss) = read_in_stride("$INPUT_FILE.stride");
        $len = length($seq);
    } else {
        die "ERROR: Could not find neither .ss2 nor .stride file. Can not calculate length of the protein";
    }
    push(@data,$len);
    push(@index,"$index LENGTH");
    $index++;   
}

if ($EXPOSED) {
    my @rsa = read_in_rsa("$INPUT_FILE.rsa");
    my @acc = read_in_acc("$INPUT_FILE.acc");
    die "ERROR: .rsa and .acc lengths do not match" if ($#rsa != $#acc);
    my $correct = 0;
    my $count = $#rsa+1;
    for (my $i = 0; $i <= $#rsa; $i++) {
        if (($rsa[$i] < 25) && ($acc[$i] eq "b") || ($rsa[$i] > 25) && ($acc[$i] eq "e")) {
            $correct++;
        }
    }
    push(@data,$correct/$count);
    push(@index,"$index EXPOSED");
    $index++;
}

if ($FATNESS) {
    my $fatness_out = `$FATNESS_BIN $INPUT_FILE`;
    push(@data,$fatness_out);
    push(@index,"$index FATNESS");
    $index++;   
}

if ($RMSD) {
    my $tm_file;
    if ( -f "$INPUT_FILE.fixed.TM" ) {
        $tm_file = "$INPUT_FILE.fixed.TM";
    } elsif ( -f "$INPUT_FILE.TM") {
        $tm_file = "$INPUT_FILE.TM";
    } else {
        die "ERROR: TM-score file $INPUT_FILE.TM does not exist\n";
    }
    $target_score = parse_score($tm_file,"-rmsd");
} elsif ($SSCORE) {
    $target_score = sscore("$INPUT_FILE.S.$SSCORE");
} elsif ($SSUM) {
    $target_score = sscore("$INPUT_FILE.S.$SSUM");
}


#print "@data\n";
#print "@index\n";

write_results();

print "$0 done.\n";

###################### subroutines ######################

sub debug {
    #print "@data\n";
    #print "@index\n";
    
    #print "$seq\n";
    #print "$ss_pred\n";
    #print "$seq2\n";
    #print "$stride_pred\n";
    #if ($seq eq $seq2) {
    #   print "good!\n";
    #}
}

sub sscore {
    my $input_file = shift;
    my $sum = 0;
    my $count = 0;
    open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";
    while (my $line=<IN_FILE>) {
        if ($line =~ m/\d+\s+\w\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)/) {
            my $s_local = $1;
            $sum += $s_local;
            $count++;
        }
    }   
    close(IN_FILE) or die "Error occured closing input file: $!";
    if ($SSCORE) {
        return $sum/$count;
    } elsif ($SSUM) {
        return $sum;
    } else {
        die "ERROR: SSUM and SSCORE are not defined";
    }
}

sub option_string {
    my $option_string = "svm";
    my $i = 0;
    while ( $i <= $#_ ) {
        if (($_[$i] ne "-in") && ($_[$i] ne "-out")) {
            #print "$_[$i]\n";
            $option_string .= $_[$i];
            $i++;
        } else {
            $i += 2;
        }
    }
    return $option_string;
}

sub write_results {
    my $base = basename($INPUT_FILE);
    my $svm_file = "$OUTPUT_DIR/$SUBDIR/$base.svm";
    my $index_file = "$OUTPUT_DIR/$SUBDIR/$base.index";
    if ( ! -d "$OUTPUT_DIR/$SUBDIR" ) {
        my $cmd = "mkdir $OUTPUT_DIR/$SUBDIR";
        system($cmd);
    }
    #print "$svm_file\n";
    open(SVM_FILE,">$svm_file") or die "Error occured opening output file: '$svm_file': $!";
    open(INDEX_FILE,">$index_file") or die "Error occured opening output file: '$index_file': $!";
    
    print SVM_FILE "$target_score ";
    for (my $i = 0; $i <= $#index; $i++) {
        my $ii = $i + 1;
        print SVM_FILE "$ii:$data[$i] ";
        print INDEX_FILE "$index[$i]\n";
    }
    print SVM_FILE "\n";

    close(SVM_FILE) or die "Error occured closing output file: $!";
    close(INDEX_FILE) or die "Error occured closing output file: $!";
}

sub parse_proqres {
    my $keyword = $_[0];            # keyword = ATOM / RES / SURF25 / SURF50 / SURF75 / SURF100
    for (my $i = 0; $i <= $#proq_res_arr; $i++) {
        my $line = $proq_res_arr[$i];
        if ($line =~ /^$keyword/) {
            #print "$line\n";
            my @temp = split(/\s+/, $line);
            for (my $j = 1; $j <= $#temp; $j++) {
                push(@data, $temp[$j]);
                push(@index, "$index $keyword $j");     
                $index++;   
            }
            last;
        }
    }
}

sub compare_secondary {
    my $ss1 = $_[0];
    my $ss2 = $_[1];
    my $correct=0;
    my $count=0;
    
    #print "$ss1\n";
    #print "$ss2\n";
    
    for my $i (0 .. length($ss1)) {
        my $s1 = substr($ss1,$i,1);
        my $s2 = substr($ss2,$i,1);
        if ($s1 eq $s2) {
            $correct++;
        }
        $count++;
    }

    push(@data,$correct/$count);
    push(@index,"$index SECONDARY");
    $index++;
}

sub read_in_acc {
    my $input_file=shift;
    open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";
    my @contents = <IN_FILE>;
    my $lastline = pop(@contents);
    chomp $lastline;
    my @acc=split(//,$lastline);
    close(IN_FILE) or die "Error occured closing input file: $!";
    return @acc;
}

sub read_in_rsa {
    my $input_file=shift;
    my @rsa = ();
    open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";
    while(<IN_FILE>)
    {
        if(/^RES/) {
        my @temp=split(/\s+/);
            #print $_;
            #print $temp[6]."\n";
        push(@rsa,$temp[6]);
        }
    }
    close(IN_FILE) or die "Error occured closing input file: $!";
    return @rsa;
}

sub read_in_psipred2 {
    my $input_file=shift;
    my $seq="";
    my $ss_pred="";
    open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";
    while(<IN_FILE>) {
        if(/\d+\s+(\w)\s+([HCE])\s+([\d\.\-]+)\s+([\d\.\-]+)\s+([\d\.\-]+)/) {
            chomp;
            $ss_pred.=$2;
            $seq.=$1;
        }
    }
    close(IN_FILE) or die "Error occured closing input file: $!";
    return ($seq,$ss_pred);
}

sub read_in_stride
{
    my $input_file=shift;
    my $seq="";
    my $ss="";
    open(IN_FILE, "$input_file") or die "Error occured opening input file '$input_file': $!";
    while(<IN_FILE>)
    {
            chomp;
            if(/^SEQ/)
            {
                    #print substr($_,10,50)."\n";
                    $seq.=substr($_,10,50);
            }
            if(/^STR/)
            {
                    #print substr($_,10,50)."\n";
                    $ss.=substr($_,10,50);
            }
            last if(/^LOC/);
    }
    close(IN_FILE) or die "Error occured closing input file: $!";
    
    #Remove white spaces at end.
    $seq=~s/ //g;
    $ss=substr($ss,0,length($seq));
    my @temp=split(//,$ss);
    my $return_ss="";
    foreach my $ss_a(@temp)
    {
            #print $ss_a."\n";
            if($ss_a eq 'H' || $ss_a eq 'G' || $ss_a eq 'I')
            {
                    $return_ss.="H";
            }
            elsif($ss_a eq "E")
            {
                    $return_ss.="E";
            }
            else
            {
                    $return_ss.="C";
            }
        }
        #print "$seq\n$return_ss\n$ss\n";
    return($seq,$return_ss);
    
}
