#!/usr/bin/env  perl5
use  strict;
use  warnings;
use  v5.22;

## Perl5 version >= 5.22
## You can create a symbolic link for perl5 by using "sudo  ln  /usr/bin/perl   /usr/bin/perl5" in Ubuntu.
## Suffixes of all self-defined global variables must be "_g".
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $input_g  = '2-FASTA/targetRegions.N60.fasta';   
my $output_g = '3-splitFasta'; 

{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        Welcome to use sgRNA-Design, version 0.3.0, 2016-11-22.

        Step 2: Split the fasta file by using GenomeTools.       

        Usage:  perl  sgRNA-Design_2.pl    [-version]    [-help]   
        For instance: perl  sgRNA-Design_2.pl   >> sgRNA-Design_2.runLog 2>&1  

        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.
        -help           Show this help message and exit.
        -----------------------------------------------------------------------------------------------------------

        For more details, please visit https://github.com/CTLife/sgRNA 
        Yong Peng @ He lab, yongp@outlook.com, Academy for Advanced Interdisciplinary Studies
        and Peking-Tsinghua Center for Life Sciences (CLS), Peking University, China.
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "    The Second Step of sgRNA-Design, version 0.3.0, 2016-11-22.";

## Keys and Values
##if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Available Arguments 
my $available = "   -version    -help      ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl  sgRNA-Design_2.pl  -help' \n";
    exit 0;
}

## Get Arguments 
if ( exists $args{'-version' }   )     { say  "\n$version\n";    exit 0; }
if ( exists $args{'-help'    }   )     { say  "\n$HELP\n";       exit 0; }

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

&printVersion(" gt --version ");  ## GenomeTools
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
{
say   "\n\n\n\n\n\n##################################################################################################";

say   "Split fasta file ......";
system("gt  splitfasta   -splitdesc $output_g    $input_g ");

}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n";





## END
