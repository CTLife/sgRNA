#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.20;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "7-DistanceFilter";
my $outDir   = "8-Top500";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);

open(outFILE_g1,   ">", "$outDir/z_removed-all.txt")   or die "$!";
open(outFILE_g2,   ">", "$outDir/z_number_sgRNA_eachTarget.txt")   or die "$!";

my $total_sgRNA = 0;

for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fasta$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]") or die "$!"; 
        open(outFILE1,   ">", "$outDir/$inputFiles_g[$i]")   or die "$!"; 

        my @lines1 = <inputFILE1>;
        print  outFILE1  $lines1[0];

       my $num_sgRNA = 0;
       for (my $i1=1;  $i1<=$#lines1;  $i1++) { 
            if($i1 < 501) {
                print  outFILE1  $lines1[$i1]; 
                $num_sgRNA++; 
            }else{
                print  outFILE_g1  $lines1[$i1];  
            }
       }
 
       $total_sgRNA = $total_sgRNA + $num_sgRNA; 
       print   outFILE_g2     "$inputFiles_g[$i]\t$num_sgRNA\n";
}



print   "$total_sgRNA\n";










