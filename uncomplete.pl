#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "7-Fasta";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);

sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
my $outDir   = "7_2647Files";
&myMakeDir($outDir);




for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fa$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        if(  !(-e "9-offTarget-run1/$inputFiles_g[$i]") ) {system("cp   $inputDir/$inputFiles_g[$i]   $outDir/$inputFiles_g[$i]"   );} 
}




