#!/usr/bin/env  perl5
use  strict;
use  warnings;
use  v5.22;

## Perl5 version >= 5.22
## You can create a symbolic link for perl5 by using "sudo  ln  /usr/bin/perl   /usr/bin/perl5" in Ubuntu.
## Suffixes of all self-defined global variables must be "_g".
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $Rscript_g = '';  ## Which R scipt will be invoked, such as  sgRNA-Design_3_SpCas9_mm9.R, sgRNA-Design_3_SaCas9_mm9.R 
my $input_g   = '3-splitFasta';    
my $output_g  = '4-raw-sgRNAs'; 

{
## Help Infromation
my $HELP = '
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        Welcome to use sgRNA-Design, version 0.3.0, 2016-11-22.

        Step 3:Each sequence to be searched for potential gRNAs.       

        Usage:  perl  sgRNA-Design_3.pl    [-version]    [-help]   [-R Rscript]     
        For instance: perl  sgRNA-Design_3.pl   -R sgRNA-Design_3_SpCas9_mm9.R   >> sgRNA-Design_3.runLog 2>&1  

        ----------------------------------------------------------------------------------------------------------
        Optional arguments:
        -version        Show version number of this program and exit.
        -help           Show this help message and exit.

        Required arguments:
        -R Rscript    Which R scipt will be invoked,  such as  sgRNA-Design_3_SpCas9_mm9.R, sgRNA-Design_3_SaCas9_mm9.R .    (no default)
        -----------------------------------------------------------------------------------------------------------

        For more details, please visit https://github.com/CTLife/sgRNA 
        Yong Peng @ He lab, yongp@outlook.com, Academy for Advanced Interdisciplinary Studies
        and Peking-Tsinghua Center for Life Sciences (CLS), Peking University, China.
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------------------------------------------
';

## Version Infromation
my $version = "    The Third Step of sgRNA-Design, version 0.3.0, 2016-11-22.";

## Keys and Values
if ($#ARGV   == -1)   { say  "\n$HELP\n";  exit 0;  }       ## when there are no any command argumants.
if ($#ARGV%2 ==  0)   { @ARGV = (@ARGV, "-help") ;  }       ## when the number of command argumants is odd.
my %args = @ARGV;

## Initialize  Variables
$Rscript_g = 'sgRNA-Design_3_SpCas9_mm9.R';           ## This is only an initialization value or suggesting value, not default value.

## Available Arguments 
my $available = "   -version    -help   -R    ";
my $boole = 0;
while( my ($key, $value) = each %args ) {
    if ( ($key =~ m/^\-/) and ($available !~ m/\s$key\s/) ) {say    "\n\tCann't recognize $key";  $boole = 1; }
}
if($boole == 1) {
    say  "\tThe Command Line Arguments are wrong!";
    say  "\tPlease see help message by using 'perl  sgRNA-Design_3.pl  -help' \n";
    exit 0;
}

## Get Arguments 
if ( exists $args{'-version' }   )     { say  "\n$version\n";    exit 0; }
if ( exists $args{'-help'    }   )     { say  "\n$HELP\n";       exit 0; }
if ( exists $args{'-R'       }   )     { $Rscript_g = $args{'-R'  };     }else{say   "\n -R is required.\n";   say  "\n$HELP\n";    exit 0; }


## Conditions
$Rscript_g =~ m/^\S+$/    ||  die   "\n\n$HELP\n\n";
$Rscript_g =~ m/\.R$/     ||  die   "\n\n$HELP\n\n";


## Print Command Arguments to Standard Output
say  "\n
        ################ Arguments ###############################
                Rscript:  $Rscript_g
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

&printVersion(" R --version ");
}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
{
say   "\n\n\n\n\n\n##################################################################################################";

opendir(my $DH_input,$input_g)  ||  die;     
my @inputFiles_g = readdir($DH_input);


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {  
        my $fastaFile = $inputFiles_g[$i] ;
        next unless $fastaFile =~ m/\.fasta$/;  
        next unless $fastaFile !~ m/^[.]/;
        next unless $fastaFile !~ m/[~]$/;
        say   "\t $fastaFile ... ..." ; 
        system("Rscript  $Rscript_g   $input_g   $fastaFile   $output_g   > $output_g/find-sgRNAs.runLog.txt ");
}

}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n";





## END
