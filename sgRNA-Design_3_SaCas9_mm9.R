library(CRISPRseek)
library(BSgenome.Mmusculus.UCSC.mm9)
library(TxDb.Mmusculus.UCSC.mm9.knownGene)
library(org.Mm.eg.db)


args <- commandArgs(TRUE)
print("args: ")
print(args[1])         
print(args[2])
print(args[3])         
print("#############")


inputDir   = args[1];     ##fasta file in this folder 
inputFasta = args[2];     ##fasta file 
outPath    = args[3];     ##output file path
outPath2   = paste(outPath, inputFasta, sep="/")      ##output file path.    gRNA.pattern = "^G(?:(?!T{5,}).)+$"

if( ! file.exists(outPath) ) { dir.create(outPath,    recursive=TRUE) }







offTargetAnalysis(      
                  inputFilePath=paste(inputDir, inputFasta, sep="/"),   format="fasta",   header=FALSE,   gRNAoutputName=inputFasta,   findgRNAs=TRUE,
                  exportAllgRNAs="all",    findgRNAsWithREcutOnly=FALSE,    REpatternFile=system.file("extdata", "NEBenzymes.fa",package="CRISPRseek"), 
                  minREpatternSize=4,      overlap.gRNA.positions=c(17, 18),    findPairedgRNAOnly=FALSE,   annotatePaired=TRUE, 
                  enable.multicore=TRUE,   n.cores.max=6,    min.gap=0,   max.gap=21,    gRNA.name.prefix=inputFasta, 
                  PAM.size=6,    gRNA.size=21,  PAM="NNGRRT",   BSgenomeName=BSgenome.Mmusculus.UCSC.mm9,   
                  chromToSearch="",     chromToExclude="",                            
                  max.mismatch=3,   PAM.pattern="NNG[A|G][A|G]T$",      allowed.mismatch.PAM=2,   gRNA.pattern="",  
                  min.score=0.1,  topN=1000,   topN.OfftargetTotalScore=10,   annotateExon=TRUE,
                  txdb=TxDb.Mmusculus.UCSC.mm9.knownGene,    orgAnn=org.Mm.eg.db,   outputDir=outPath2, 
                  fetchSequence=TRUE,   upstream=200,   downstream=200,   upstream.search=0,    downstream.search=0,
                  weights=c(0, 0, 0.014, 0, 0, 0.395, 0.317, 0, 0.389, 0.079, 0.445, 0.508, 0.613, 0.851, 0.732, 0.828, 0.615, 0.804, 0.685, 0.583),
                  baseBeforegRNA=4,    baseAfterPAM=3,    featureWeightMatrixFile=system.file("extdata",  "DoenchNBT2014.csv",  package="CRISPRseek"), 
                  useScore=TRUE,      useEfficacyFromInputSeq=FALSE,      outputUniqueREs=TRUE,     foldgRNAs=FALSE,
                  gRNA.backbone="GUUUUAGAGCUAGAAAUAGCAAGUUAAAAUAAGGCUAGUCCGUUAUCAACUUGAAAAAGUGGCACCGAGUCGGUGCUUUUU", 
                  temperature=37,   overwrite=FALSE,   scoring.method="CFDscore",
                  subPAM.activity = hash( AA = 0,
                                    AC = 0,
                                    AG = 0.259259259,
                                    AT = 0,
                                    CA = 0,
                                    CC = 0,
                                    CG = 0.107142857,
                                    CT = 0,
                                    GA = 0.069444444,
                                    GC = 0.022222222,
                                    GG = 1,
                                    GT = 0.016129032,
                                    TA = 0,
                                    TC = 0,
                                    TG = 0.038961039,
                                    TT = 0),
                  subPAM.position=c(22, 23),  PAM.location = "3prime",   mismatch.activity.file=system.file("extdata", "NatureBiot2016SuppTable19DoenchRoot.csv", package="CRISPRseek")
)




























