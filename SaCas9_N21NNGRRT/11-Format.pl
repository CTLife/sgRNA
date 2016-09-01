#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "10-offTarget";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);

sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
my $outDir   = "11-Format";
my $tempDir  = "yp-temp-for-11-Format";
&myMakeDir($outDir);
&myMakeDir($tempDir);





if (0==0) {
for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fasta$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]/OfftargetAnalysis.xls")  or die "##\n\n$inputFiles_g[$i]\n\n##"; 
        my @lines1 = <inputFILE1>;
        &myMakeDir("$tempDir/$inputFiles_g[$i]");
        for (my $j=1;  $j<=$#lines1;  $j++) {   ##The 1st column is skipped.
            $lines1[$j] =~ m/^(\S+)\s+/ or die;  
            my $name = $1;
            $name =~ s/\"//g  or  die;
            $name !~ m/\"/    or  die;
            open(outFILE1,   ">>", "$tempDir/$inputFiles_g[$i]/$name")   or die "$!";       ## The same sgRANs of one enhancer are stored in the same file.
            print   outFILE1   $lines1[$j];
        }
}
}




opendir(my $DH_temp, $tempDir)  ||  die;     
my @tempFiles_g = readdir($DH_temp);
open(FILEremove,   ">",  "$outDir/removed_sgRNAs.txt")   or die "$!";  


for ( my $i=0; $i<=$#tempFiles_g; $i++ ) {   ## one cycle is one folder (one enhancer).
        next unless $tempFiles_g[$i] =~ m/fasta$/;  
        next unless $tempFiles_g[$i] !~ m/^[.]/;
        next unless $tempFiles_g[$i] !~ m/[~]$/;
        opendir(my $DH_temp1, "$tempDir/$tempFiles_g[$i]")  ||  die;     
        my @tempFiles1 = readdir($DH_temp1);

        open(inputFILE1, "<", "$inputDir/$tempFiles_g[$i]/OfftargetAnalysis.xls") or die "$!"; 
        my @lines1 = <inputFILE1>;
        open(FILE2,   ">",  "$outDir/$tempFiles_g[$i].txt")   or die "$!";  
        print     FILE2      "sgRNA\tPAM\tOfftargetScore\t$lines1[0]";

        for (my $j=0;  $j<=$#tempFiles1;  $j++) {   ## one cycle is one sgRNA.
            next unless $tempFiles1[$j] =~ m/\_\_$/;  
            next unless $tempFiles1[$j] !~ m/^[.]/;
            next unless $tempFiles1[$j] !~ m/[~]$/;
            open(FILE1,   "<",  "$tempDir/$tempFiles_g[$i]/$tempFiles1[$j]")   or   die "$!";    
            my @tempLines1 = <FILE1>;  
            my $score = 100; 
            my $top10score = 0; 
            my $bool  = 0;
            my $index = "";
            for (my $k=0;  $k<=$#tempLines1;  $k++) {  ## one cycle is one of the same sgRNAs.
                 ##say   $tempLines1[$k];
                 $tempLines1[$k] =~ m/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+/  or  die; 
                 my $name1    = $1;
                 my $gRNAPAM1 = $2;
                 my $score1   = $7;       
                 my $chrom1   = $14;       
                 my $start1   = $15;       
                 my $end1     = $16; 
                 $name1    =~ s/\"//g    or  die;
                 $gRNAPAM1 =~ s/\"//g    or  die;
                 $score1   =~ s/\"//g    or  die;       
                 $chrom1   =~ s/\"//g    or  die;      
                 $start1   =~ s/\"//g    or  die;       
                 $end1     =~ s/\"//g    or  die; 
                 ($score >= $score1)  or  die; 
                 $score = $score1;      
                 if($k==0) {($score1 == 100)  or die; }     
                 if($k<=10) {$top10score = $top10score+$score1; }
                 $name1 =~ m/\_(chr[\dXY]+):(\d+)\-(\d+)\_/  or  die; 
                 my $chrom2 = $1;    
                 my $start2 = $2;    
                 my $end2   = $3; 
                 $gRNAPAM1 !~ m/TTTTT/  or  die;    
                 $gRNAPAM1 =~ m/^([AGCT]{21})([AGCT][AGCT]G[AG][AG]T)$/  or  die;    
                 my $sgRNA = $1;
                 my $PAM = $2;
                 $chrom1 =~ m/^chr/    or  die;
                 if( ($bool == 0) and ($chrom1 eq $chrom2) and ($start2 <= $start1) and ($end2 >= $end1) ) {
                       ($score1 == 100)   or  die "##\n\n$tempLines1[$k]\n\n##";
                       $top10score = $top10score - $score1;
                       ##print  FILE2  "$sgRNA\t$PAM\t$top10score\t$tempLines1[$k]";   
                       $bool++;
                       $index = $k;
                 }  
                 if($k==$#tempLines1) { 
                     if($bool == 1) {  
                         print  FILE2  "$sgRNA\t$PAM\t$top10score\t$tempLines1[$index]";  
                     }else{
                         ($bool == 0)  or  die;
                         print  FILEremove  "$sgRNA\t$PAM\t$top10score\t$tempLines1[0]";  
                     } 
                     say   "$k+1, $index";                         
                 }
            }                      
        }

}



















