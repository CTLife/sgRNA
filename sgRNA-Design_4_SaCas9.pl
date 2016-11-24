#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.20;
use  List::UtilsBy qw( nsort_by );

## remove sgRNAs with target score is no more than 0.1.
## remove sgRNAs with "N" or "TTTTT".
## remove sgRNAs with enzyme cut sites.


my $inputDir = "4-raw-sgRNAs";
my $outDir   = "5-filtered-sgRNAs";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);

open(outFILE_g1,   ">", "$outDir/removed-all.txt")   or die "$!";
open(outFILE_g2,   ">", "$outDir/removed-enzyme.txt")   or die "$!";
open(outFILE_g3,   ">", "$outDir/number_sgRNA_eachTarget.txt")   or die "$!";
 
for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fasta$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        next unless ( -e "$inputDir/$inputFiles_g[$i]/gRNAefficacy.xls");
        say   "\t $inputFiles_g[$i] ... ..." ; 

        my $temp1 = "$outDir/$inputFiles_g[$i]";
        &myMakeDir($temp1);
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]/gRNAefficacy.xls") or die "$!"; 
        open(inputFILE2, "<", "$inputDir/$inputFiles_g[$i]/REcutDetails.xls") or die "$!"; 
        open(outFILE1,   ">", "$temp1/gRNAefficacy.xls")   or die "$!"; 
        my @lines1 = <inputFILE1>;
        my @lines2 = <inputFILE2>;

        my $sgRNAwithEnzyme = '';
        for (my $i2=1; $i2<=$#lines2; $i2++) {
             $lines2[$i2] =~ s/\"//g or die;   
             if($lines2[$i2] =~ m/\tBsmBI\t/) {
                 $sgRNAwithEnzyme = $sgRNAwithEnzyme."\t$lines2[$i2]\t";
                 print    outFILE_g2    $lines2[$i2];
             }   
        }

        $lines1[0] =~ s/\"//g  or die;
        print   outFILE1    $lines1[0];

        my $number_sgRNA = 0;
        for (my $i=1; $i<=$#lines1; $i++) {
             $lines1[$i] =~ s/\"//g  or die;
             $lines1[$i] =~ m/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*/ or die;   
             my $gRNAplusPAM = $1;
             my $name = $2;
             my $start = $3;
             my $strand = $4;
             my $extendedSequence = $5;
             my $gRNAefficacy = $6;
             (length($gRNAplusPAM) == 27)    or  die;
             $gRNAplusPAM =~ m/[AGCT][AGCT]G[AG][AG]T$/  or die;
             if( ($gRNAefficacy =~ m/^[\.\d]+$/) and ($gRNAefficacy > 0.1) and ($gRNAplusPAM !~ m/N/) and ($gRNAplusPAM !~ m/TTTTT/) and ($sgRNAwithEnzyme !~ m/\t$gRNAplusPAM\t/) ) { 
                 print   outFILE1    $lines1[$i];  
                 $number_sgRNA++;
             }else{
                 print   outFILE_g1    $lines1[$i];  
             }
        }
        print   outFILE_g3    "$inputFiles_g[$i]\t$number_sgRNA\n";
}










