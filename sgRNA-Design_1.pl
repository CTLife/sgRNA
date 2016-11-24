#!/usr/bin/env  perl5
use  strict;
use  warnings;
use  v5.22;

## Perl5 version >= 5.22
## You can create a symbolic link for perl5 by using "sudo  ln  /usr/bin/perl   /usr/bin/perl5" in Ubuntu.
## Suffixes of all self-defined global variables must be "_g".
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $genome_g = '';  ## such as "1-rawData/mm10.fasta", "1-rawData/ce11.fasta", "1-rawData/hg38.fasta".    
my $input_g  = '';  ## such as "1-rawData/targetRegions.bed"   
my $output_g = '2-FASTA'; 

{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        Welcome to use sgRNA-Design, version 0.3.0, 2016-11-22.

        Step 1: Convert BED format to fasta format by using bedtools, and add "N{60}" before and after each sequence.       

        Usage:  perl  sgRNA-Design_1.pl    [-version]    [-help]   [-genome RefGenome]    [-in inputFile]    
        For instance: perl  sgRNA-Design_1.pl   -genome 1-rawData/mm9.fasta   -in 1-rawData/targetRegions.bed    >> sgRNA-Design_1.runLog 2>&1  

        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.
        -help           Show this help message and exit.

        Required arguments:
        -genome RefGenome    "RefGenome" is the fasta file of your reference genome, such as "mm10.fasta", "ce11.fasta", "hg38.fasta".    (no default)
        -in inputFile        "inputFile" is the bed file with target regions.  (no default)
        -----------------------------------------------------------------------------------------------------------

        For more details, please visit https://github.com/CTLife/sgRNA 
        Yong Peng @ He lab, yongp@outlook.com, Academy for Advanced Interdisciplinary Studies
        and Peking-Tsinghua Center for Life Sciences (CLS), Peking University, China.
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "    The First Step of sgRNA-Design, version 0.3.0, 2016-11-22.";

## Keys and Values
if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Initialize  Variables
$genome_g = '1-rawData/mm9.fasta';           ## This is only an initialization value or suggesting value, not default value.
$input_g  = '1-rawData/targetRegions.bed';   ## This is only an initialization value or suggesting value, not default value.

## Available Arguments 
my $available = "   -version    -help   -genome   -in    ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl  sgRNA-Design_1.pl  -help' \n";
    exit 0;
}

## Get Arguments 
if ( exists $args{'-version' }   )     { say  "\n$version\n";    exit 0; }
if ( exists $args{'-help'    }   )     { say  "\n$HELP\n";       exit 0; }
if ( exists $args{'-genome'  }   )     { $genome_g = $args{'-genome'  }; }else{say   "\n -genome is required.\n";   say  "\n$HELP\n";    exit 0; }
if ( exists $args{'-in'      }   )     { $input_g  = $args{'-in'      }; }else{say   "\n -in     is required.\n";   say  "\n$HELP\n";    exit 0; }

## Conditions
$genome_g =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$input_g  =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";

## Print Command Arguments to Standard Output
say  "\n
        ################ Arguments ###############################
                Reference Genome:  $genome_g
                Input       File:  $input_g
        ###############################################################
\n";
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "Running ......";

sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die;       }
}

&myMakeDir("$output_g");
###################################################################################################################################################################################################





###################################################################################################################################################################################################
{
## These commands must be available:
say   "\n\n\n\n\n\n##################################################################################################";
say   "Checking all the necessary softwares in this step ......";

sub printVersion  {
    my $software = $_[0];
    system("echo    '##############################################################################'  >> $output_g/VersionsOfSoftwares.txt   2>&1");
    system("echo    '#########$software : '                                                           >> $output_g/VersionsOfSoftwares.txt   2>&1");
    system("$software                                                                                 >> $output_g/VersionsOfSoftwares.txt   2>&1");
    system("echo    '\n\n\n\n\n\n'                                                                    >> $output_g/VersionsOfSoftwares.txt   2>&1");
}

&printVersion(" bedtools --version ");
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
{
say   "\n\n\n\n\n\n##################################################################################################";

say   "Check the BED file $input_g ......";
open(inputFH,   "<",   $input_g)  or  die;
while(my $line = <inputFH>) {
    $line =~ m/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*/ or die; 
    my $fourthColumn = $4;
    $fourthColumn =~ m/\_(chr\S{1,5})\:(\d+)\-(\d+)/  or die "## The format is wrong: $line ##\n";
}

say   "Convert bed to fasta ......";
system("bedtools getfasta    -name    -fi  $genome_g    -bed  $input_g     -fo  $output_g/targetRegions.fasta     >  $output_g/bed2fasta.runLog.txt   ");

say   'add "NNNNN" before and after each sequence ......';
open(outputFH,    "<",   "$output_g/targetRegions.fasta")  or  die;
open(outputFH2,   ">",   "$output_g/targetRegions.N60.fasta")  or  die;
while(my $line = <outputFH>) {
    $line =~ m/^>\S+/ or die; 
    print  outputFH2 $line; 
    $line = <outputFH> ; 
    $line =~ m/^([AGCTN]+)\s*$/i or die "## $line ##\n" ; 
    my $DNAsequence = $1; 
    $DNAsequence = "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN".$DNAsequence."NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";    
    print  outputFH2   "$DNAsequence\n"; 
}

}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n";





## END
