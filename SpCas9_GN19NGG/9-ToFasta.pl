#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "8-Top500";
my $outDir   = "9-ToFasta";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fasta$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        my $temp1 = "$outDir/$inputFiles_g[$i]";
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]") or die "$!"; 
        open(outFILE1,   ">", $temp1)   or die "$!"; 
        my @lines1 = <inputFILE1>;

        for (my $i1=1; $i1<=$#lines1; $i1++) { 
                  $lines1[$i1] =~ m/^(\S+)\s+(\S+)\s+/ or die;         
                  my $sgRNA = $1;
                  my $name  = $2;
                  $lines1[$i1] =~ s/\s/_/g or die; 
                  print  outFILE1  ">$name\_$lines1[$i1]\n";
                  print  outFILE1  "$sgRNA\n";
        }
}










