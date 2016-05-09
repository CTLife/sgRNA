#!/usr/bin/env perl5
use  strict;
use  warnings;
use  v5.18;
use  List::UtilsBy qw( nsort_by );


my $inputDir = "10-Format";
my $outDir   = "11-Top5Offtarget";
opendir(my $DH_input, $inputDir)  ||  die;     
my @inputFiles_g = readdir($DH_input);
sub myMakeDir  {
    my $path = $_[0];
    if ( !( -e $path) )  { system("mkdir  -p  $path"); }
    if ( !( -e $path) )  { mkdir $path  ||  die; }
}
&myMakeDir($outDir);
open(outFILE3,   ">", "$outDir/less5.txt")   or die "$!"; 


for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {   
        next unless $inputFiles_g[$i] =~ m/\.fa$/;  
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        open(inputFILE1, "<", "$inputDir/$inputFiles_g[$i]") or die "$!"; 
        open(outFILE1,   ">", "$outDir/$inputFiles_g[$i]")   or die "$!"; 
        open(outFILE2,   ">", "$outDir/removed.$inputFiles_g[$i].txt")   or die "$!"; 
        my @lines1 = <inputFILE1>;
        print  outFILE1   $lines1[0];
        print  outFILE2   $lines1[0];
        my @array2d = '';   #声明一个数组,此时数组的第一个元素是有值的，为空值。若使用“my @array2d = ();”，则$array2d[0]的值也为undef,即所有元素都是没有值的。
        my $num_columns = 18;
        for (my $i1=1; $i1<=$#lines1; $i1++) {                                #数组@lines的第一个元素不做处理。
                  $lines1[$i1] =~ s/ ^\s* ([^\n]+) \s*$ /$1/x or die;         #去掉首尾的空格。
                  $array2d[$i1-1] = [split(/\t+/,$lines1[$i1])];              #用方括号生成匿名引用。
                  say $array2d[$i1-1][3];
                  #my $num_columns1 =  $#array2d[$i1-1];  
                  #($num_columns == $num_columns1)  or  die;   
        }	                                                              #现在@array2d是一个L*6维的2维数组。L是sgRNA数目.
       my @sorted_array2d = nsort_by { $_->[2] } @array2d;

       for (my $i=0;  $i<$#lines1;  $i++) { 
           if ($i<=4) {
           for (my $j=0; $j<=$num_columns; $j++) {
               print outFILE1   "$sorted_array2d[$i][$j]\t"; 
           }
           print   outFILE1   "\n"; 
           }else{
           for (my $k=0; $k<=$num_columns; $k++) {
               print outFILE2   "$sorted_array2d[$i][$k]\t"; 
           }
           print   outFILE2   "\n"; 
           }
      }
      my $num_gRNAs = $#lines1 + 1;
      if($num_gRNAs<5) {print  outFILE3  "$inputFiles_g[$i]\t$num_gRNAs\n"; }
}









