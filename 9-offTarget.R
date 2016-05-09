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
outPath2   = paste(outPath, inputFasta, sep="/")      ##output file path
if( ! file.exists(outPath) ) { dir.create(outPath)  }
if( ! file.exists(outPath) ) { dir.create(outPath2) }



offTargetAnalysis(inputFilePath = paste(inputDir, inputFasta, sep="/"),    format = "fasta",     header = FALSE, 
                  gRNAoutputName = inputFasta ,       findgRNAs = FALSE,  exportAllgRNAs = "all",  
                  findgRNAsWithREcutOnly = FALSE,       REpatternFile = system.file("extdata", "NEBenzymes.fa", package = "CRISPRseek"),   
                  minREpatternSize = 4,   overlap.gRNA.positions = c(17, 18), 
                  findPairedgRNAOnly = FALSE,   annotatePaired = FALSE,    enable.multicore = TRUE,
                  min.gap = 0,   max.gap = 20,   gRNA.name.prefix = inputFasta,    
                  PAM.size = 3,  gRNA.size = 20,    PAM = "NGG",   
                  BSgenomeName=BSgenome.Mmusculus.UCSC.mm9,   chromToSearch = "all", 
                  chromToExclude = c("chr17_ctg5_hap1","chr4_ctg9_hap1", "chr6_apd_hap1", "chr6_cox_hap2", "chr6_dbb_hap3", "chr6_mann_hap4", "chr6_mcf_hap5","chr6_qbl_hap6","chr6_ssto_hap7"),
                  max.mismatch = 3, PAM.pattern = "N[A|G]G$", allowed.mismatch.PAM = 2, 
                  gRNA.pattern = "",   min.score = 0.5,   topN = 100, 
                  topN.OfftargetTotalScore = 10,   annotateExon = FALSE,
                  txdb = TxDb.Mmusculus.UCSC.mm9.knownGene,   orgAnn = org.Mm.eg.db, 
                  outputDir = outPath2, 
                  fetchSequence = TRUE,   upstream = 200,    downstream = 200, 
                  upstream.search = 0,   downstream.search = 0,
                  weights = c(0, 0, 0.014, 0, 0, 0.395, 0.317, 0, 0.389, 0.079, 0.445, 0.508, 0.613, 0.851, 0.732, 0.828, 0.615, 0.804, 0.685, 0.583),
                  baseBeforegRNA = 4,    baseAfterPAM = 3,
                  featureWeightMatrixFile = system.file("extdata", "DoenchNBT2014.csv", package = "CRISPRseek"), useScore = TRUE, useEfficacyFromInputSeq = FALSE,
                  outputUniqueREs = TRUE, foldgRNAs = TRUE, 
                  gRNA.backbone="GUUUUAGAGCUAGAAAUAGCAAGUUAAAAUAAGGCUAGUCCGUUAUCAACUUGAAAAAGUGGCACCGAGUCGGUGCUUUUUU",
                  temperature = 37,   overwrite = FALSE )









