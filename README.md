# sgRNA
Design genom-wide sgRNAs by using [CRISPRseek](http://bioconductor.org/packages/release/bioc/html/CRISPRseek.html).                                             
There is to be no limitation on the number and length of target sequences.                 
_________________________                                
# Steps:                   
1. Based on target regions (targetRegions.bed) and reference genome (such as mm9.fasta),  covert the bed to fasta (targetRegions.fasta) by using bedtools.                                                  
2. Split fasta file (targetRegions.fasta) into many fasta files by using Genometools.    
 It is required that one sequence is corresponding to one file.                                            
3. Search sgRNAs for each enhancer:                      
      SaCas9: N21+NNGRRT                                    
      SpCas9: N20+NRG       
4.  Remove the raw sgRNAs with "N",  "TTTT", BsmBI enzyme cut sites, and target score is no more than 0.1.                                            
       For SpCas9, only GN19+NGG sgRNAs are kept.                           
5.  For each enhancer, its top 500 sgRNAs are kept based on their target scores.                                    
6.  For each enhancer, the distance of its any two sgRNAs must be more than 50 bp.                                          
7.  For each enhancer, its top 50 sgRNAs are kept based on their target scores.                                       
8.  Convert the sgRNA files into fasta format for searching offtarget scores.                          
10. Remove the sgRNAs with  offtarget score >= 20.       
11. For each enhancer, its top 10 sgRNAs are kept based on their target scores.         
12. Merge.            
