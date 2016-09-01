#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.20;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "5-select-sgRNAs";
my $outDir   = "6-Top-sgRNAs";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);
open(outFILE_g1,   ">", "$outDir/removed-all.txt")   or die "$!";


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fasta$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        next unless ( -e "$inputDir/$inputFiles_g[$i]/gRNAefficacy.xls");
        say   "\t$inputFiles_g[$i] ... ..." ; 
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]/gRNAefficacy.xls") or die "$!"; 
        my @lines1 = <inputFILE1>;
        next unless ($#lines1>=1);

        my $temp1 = "$outDir/$inputFiles_g[$i]";
        &myMakeDir($temp1);
        open(outFILE1,   ">", "$temp1/gRNAefficacy.xls")   or die "$!"; 

        my @array2d = '';   #声明一个数组,此时数组的第一个元素是有值的，为空值。若使用“my @array2d = ();”，则$array2d[0]的值也为undef,即所有元素都是没有值的。
        for (my $i1=1; $i1<=$#lines1; $i1++) {                                #数组@lines的第一个元素不做处理。
                  $lines1[$i1] =~ s/ ^\s* ([^\n]+) \s*$ /$1/x or die;         #去掉首尾的空格。
                  $array2d[$i1-1] = [split(/\t+/,$lines1[$i1])];              #用方括号生成匿名引用。
                  $#{$array2d[$i1-1]} == 5 or die "\n$array2d[$i1]\n";        #看成一维数组时，其每个元素均为6维的数组。
        }	                                                              #现在@array2d是一个L*6维的2维数组。L是sgRNA数目.
       my @sorted_array2d = reverse nsort_by { $_->[5] } @array2d;

       print  outFILE1  $lines1[0]; 
       for (my $i=0;  $i<$#lines1;  $i++) { 
           $sorted_array2d[$i][0] =~ m/^G[AGCT]{19}[AGCT]GG$/  or die;
           $sorted_array2d[$i][0] !~ m/TTTTT/  or die;
           if($i < 500) { 	## top 500 are kept.
               for (my $j=0; $j<=5; $j++) {
                   print outFILE1  "$sorted_array2d[$i][$j]\t";
               }
               print outFILE1 "\n";
           }else{
               for (my $j=0; $j<=5; $j++) {
                   print outFILE_g1  "$sorted_array2d[$i][$j]\t";
               }
               print outFILE_g1 "\n";
           }
       }

}










