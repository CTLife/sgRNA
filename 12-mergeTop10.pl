#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "10-Format";
my $outDir   = "12-mergeTop10";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);


open(outFILE1,   ">", "$outDir/5008_Enhancers_Top10sgRNAs.txt")   or die "$!"; 
open(outFILE2,   ">", "$outDir/num_sgRNA_distribution_for_each_Enhancer.txt")   or die "$!"; 

my $num = 0;
for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fa$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]") or die "$!";  
        my @lines1 = <inputFILE1>;
        if($num==0) {print  outFILE1  @lines1;}
        if($num> 0) {$lines1[0] = '';   print  outFILE1  @lines1;}
        my $num_sgRNA = $#lines1 ;
        print  outFILE2  "$inputFiles_g[$i]\t$num_sgRNA\n";
        $num++;
}


print  "number of enhancers: $num\n";






