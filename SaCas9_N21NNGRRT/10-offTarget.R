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
outPath2   = paste(outPath, inputFasta, sep="/")      ##output file path    gRNA.pattern = "^G(?:(?!T{5,}).)+$"
if( ! file.exists(outPath) ) { dir.create(outPath, recursive = TRUE)  }
#if( ! file.exists(outPath2) ) { dir.create(outPath2, recursive = TRUE) }



offTargetAnalysis(inputFilePath = paste(inputDir, inputFasta, sep="/"),   format = "fasta",   header = FALSE,
		gRNAoutputName = inputFasta ,   findgRNAs = FALSE,  exportAllgRNAs = "all",    findgRNAsWithREcutOnly = FALSE,
		REpatternFile = system.file("extdata", "NEBenzymes.fa", package = "CRISPRseek"),  minREpatternSize = 4,
		overlap.gRNA.positions = c(17, 18),     findPairedgRNAOnly = FALSE,   annotatePaired = FALSE,    enable.multicore = TRUE,     n.cores.max = 6,
		min.gap = 0,    max.gap = 20,    gRNA.name.prefix = inputFasta,     
		PAM.size = 6,   gRNA.size = 21,   PAM = "NNGRRT",    BSgenomeName=BSgenome.Mmusculus.UCSC.mm9,     chromToSearch = "all",
		chromToExclude = c("chr17_ctg5_hap1","chr4_ctg9_hap1", "chr6_apd_hap1","chr6_cox_hap2", "chr6_dbb_hap3", "chr6_mann_hap4",  "chr6_mcf_hap5", "chr6_qbl_hap6", "chr6_ssto_hap7"),                                  
		max.mismatch = 3,   PAM.pattern = "NNG[A|G][A|G]T$",   allowed.mismatch.PAM = 4,
		gRNA.pattern = "",    min.score = 0,   topN = 1000,
		topN.OfftargetTotalScore = 10,    annotateExon = TRUE,
		txdb = TxDb.Mmusculus.UCSC.mm9.knownGene,   orgAnn = org.Mm.eg.db,    outputDir = outPath2, 
                fetchSequence = TRUE, upstream = 200, downstream = 200,
		upstream.search = 0, downstream.search = 0,
		weights = c(0, 0, 0.014, 0, 0, 0.395, 0.317, 0, 0.389, 0.079, 0.445, 0.508, 0.613, 0.851, 0.732, 0.828, 0.615, 0.804, 0.685, 0.583,  0.5),
		baseBeforegRNA = 4, baseAfterPAM = 3,
		featureWeightMatrixFile = system.file("extdata", "DoenchNBT2014.csv", package = "CRISPRseek"), useScore = TRUE, useEfficacyFromInputSeq = FALSE,
		outputUniqueREs = TRUE,    foldgRNAs = FALSE,
                gRNA.backbone="GUUUUAGAGCUAGAAAUAGCAAGUUAAAAUAAGGCUAGUCCGUUAUCAACUUGAAAAAGUGGCACCGAGUCGGUGCUUUUU", 
		temperature = 37,
		overwrite = FALSE,
		scoring.method = "Hsu-Zhang"
)




