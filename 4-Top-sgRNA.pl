#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.20;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "3-sgRNAs";
my $outDir   = "4-Top-sgRNA";
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
        say   "\t$inputFiles_g[$i] ... ..." ; 
        my $temp1 = "$outDir/$inputFiles_g[$i]";
        &myMakeDir($temp1);
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]/gRNAefficacy.xls") or die "$!"; 
        open(inputFILE2, "<", "$inputDir/$inputFiles_g[$i]/REcutDetails.xls") or die "$!"; 
        open(outFILE1,   ">", "$temp1/gRNAefficacy.xls")   or die "$!"; 
        open(outFILE2,   ">", "$temp1/remove-1-enzyme.txt")   or die "$!"; 
        open(outFILE3,   ">", "$temp1/remove-2-NA.txt")   or die "$!"; 
        open(outFILE4,   ">", "$temp1/remove-3-lowScore.txt")   or die "$!"; 
        my @lines1 = <inputFILE1>;
        my @lines2 = <inputFILE2>;
        my $sgRNAwithEnzyme = '';
        for (my $i2=1; $i2<=$#lines2; $i2++) {
             $lines2[$i2] =~ s/\"//g or die;   
             if($lines2[$i2] =~ m/\tBsmBI\t/) {$sgRNAwithEnzyme = $sgRNAwithEnzyme."\t$lines2[$i2]\t";}
        }
        say   outFILE2  $sgRNAwithEnzyme;
        say   outFILE2  "##########################################";

        my @array2d = '';   #声明一个数组,此时数组的第一个元素是有值的，为空值。若使用“my @array2d = ();”，则$array2d[0]的值也为undef,即所有元素都是没有值的。
        my @array2d_final = '';
        my $index1 = 0;
        for (my $i1=1; $i1<=$#lines1; $i1++) {                                #数组@lines的第一个元素不做处理。
                  $lines1[$i1] =~ s/ ^\s* ([^\n]+) \s*$ /$1/x or die;         #去掉首尾的空格。
                  $lines1[$i1] =~ s/\"//g or die;   
                  ##say    $lines1[$i1];
                  if($lines1[$i1] =~ m/\t[.\d]+$/) {
                      $array2d[$i1-1] = [split(/\t+/,$lines1[$i1])];                 #用方括号生成匿名引用。
                      $#{$array2d[$i1-1]} == 5 or die "\n$array2d[$i1]\n";           #看成一维数组时，其每个元素均为6维的数组。
                      ##say $array2d[$i1-1][5];
                      my $sgRNA = $array2d[$i1-1][0];
                      ##say  $sgRNA;
                      if($sgRNAwithEnzyme =~ m/\t$sgRNA\t/) {
                           say  outFILE2   $lines1[$i1];
                      }else{
                           $array2d_final[$index1] = [split(/\t+/,$lines1[$i1])];
                           ##say $array2d_final[$index1][5];
                           $index1++;
                      }  
                  }else{
                     say  outFILE3   $lines1[$i1];
                  }
        }	                                                              #现在@array2d是一个L*6维的2维数组。L是sgRNA数目.
       my @sorted_array2d = reverse nsort_by { $_->[5] } @array2d_final;
       ##say   $sorted_array2d[1][5];

       print  outFILE1  $lines1[0]; 
       for (my $i=0;  $i<$index1;  $i++) { 
           $sorted_array2d[$i][0] =~ m/^G[AGCT]{20}GG$/  or die;
           $sorted_array2d[$i][0] !~ m/TTTTT/  or die;
           if($i < 50) { 	
               for (my $j=0; $j<=5; $j++) {
                   print outFILE1  "$sorted_array2d[$i][$j]\t";
               }
               print outFILE1 "\n";
           }else{
               for (my $j=0; $j<=5; $j++) {
                   print outFILE4  "$sorted_array2d[$i][$j]\t";
               }
               print outFILE4 "\n";
           }
       }

}









