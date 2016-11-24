#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;

my $inputDir = "9-FASTA";
my %args = @ARGV;
if ( exists $args{'-in'      }   )     { $inputDir  = $args{'-in' };       }
## perl   sgRNA-Design_9_SaCas9.pl   -in  xxx

my $outDir   = "10-offTarget";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);
open(FHskipped, ">>", "$outDir/skipped.txt") or die;


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fasta$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        if (  -e "$outDir/$inputFiles_g[$i]" )  {print  FHskipped  "$inputFiles_g[$i]\n";  next; }
        say   "\t$inputFiles_g[$i] ... ..." ; 
        system("Rscript   sgRNA-Design_9_SaCas9.R   $inputDir   $inputFiles_g[$i]   $outDir  ");
}





