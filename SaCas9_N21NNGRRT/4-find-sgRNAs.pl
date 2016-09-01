#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.20;

my $inputDir = "3-splitFasta";
my $outDir   = "4-find-sgRNAs";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {  
        my $fastaFile = $inputFiles_g[$i] ;
        next unless $fastaFile =~ m/\.fasta$/;  
        next unless $fastaFile !~ m/^[.]/;
        next unless $fastaFile !~ m/[~]$/;
        say   "\t $fastaFile ... ..." ; 
        system("Rscript  4-find-sgRNAs.R   $inputDir   $fastaFile   $outDir   >>4-find-sgRNAs.runLog  2>&1");
}




