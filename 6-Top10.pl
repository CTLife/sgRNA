#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "5-Distance";
my $outDir   = "6-Top10";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);




for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fa$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]") or die "$!"; 
        open(outFILE1,   ">", "$outDir/$inputFiles_g[$i]")   or die "$!"; 

        my @lines1 = <inputFILE1>;
        print  outFILE1  $lines1[0];

       for (my $i1=1;  $i1<=$#lines1;  $i1++) { 
            if($i1 < 11) {print  outFILE1  $lines1[$i1];  }
       }
       if($#lines1 < 10) {say  "$#lines1;  $inputFiles_g[$i]";}   
}













