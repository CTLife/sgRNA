#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;

my $inputDir = "2-splitFasta";
my $outDir   = "3-sgRNAs";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fa$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        say   "\t$inputFiles_g[$i] ... ..." ; 
        system("Rscript  3-sgRNAs.R  $inputDir   $inputFiles_g[$i]   $outDir   >>3-sgRNAs.runLog  2>&1");
}

