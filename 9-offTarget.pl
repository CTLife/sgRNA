#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;

my $inputDir = "8-splitDir/run1";
my %args = @ARGV;
if ( exists $args{'-in'      }   )     { $inputDir  = $args{'-in' };       }
## perl   offTarget.pl   -in  xxx

my $outDir   = "9-offTarget";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);
open(FHskipped, ">>", "skipped.txt") or die;


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fa$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        if (  -e "$outDir/$inputFiles_g[$i]" )  {print  FHskipped  "$inputFiles_g[$i]\n";  next; }
        say   "\t$inputFiles_g[$i] ... ..." ; 
        system("Rscript   9-offTarget.R   $inputDir   $inputFiles_g[$i]   $outDir  ");
}




