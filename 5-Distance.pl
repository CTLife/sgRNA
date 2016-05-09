#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "4-Top-sgRNA";
my $outDir   = "5-Distance";
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
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]/gRNAefficacy.xls") or die "$!"; 
        open(outFILE1,   ">", "$outDir/$inputFiles_g[$i]")   or die "$!"; 

        my @lines1 = <inputFILE1>;
        print  outFILE1  $lines1[0];
        print  outFILE1  $lines1[1];

       for (my $i1=2;  $i1<=$#lines1;  $i1++) { 
           $lines1[$i1] =~ m/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+$/  or  die;
           my $start1    = $3;
           my $efficacy1 = $6;
           my $bool = 0;
           for (my $j=1;  $j<$i1;  $j++) {
              $lines1[$j] =~ m/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+$/  or  die; 
              my $start2    = $3;
              my $efficacy2 = $6;
              ($efficacy2 >= $efficacy1)  or  die;
              if( (abs($start2-$start1)<50) ) {$bool = 1;  print   "$lines1[$i1]\n"; }
           }
           if( ($bool == 0) and ($efficacy1>0.1) )  {  print   outFILE1   $lines1[$i1] ; }
       }   
}













