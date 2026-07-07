# This scripts reads in aging GTEx gene signature dataset downlaoded from https://doi.org/10.5281/zenodo.6797627
# from https://pubmed.ncbi.nlm.nih.gov/36777183/

rm(list=ls())
proj.path <- "/home/EOCRC/"
library(dplyr)

# Read in gene signatures
genes.age <- readRDS(paste0(proj.path, "/src/Rdata/Data_set_1.rds"))
names(genes.age)

# Collect genes that increase with age (up in old)
genes1.old <- genes.age$ColonSigmoid$Age %>% filter(adj.P.Val < 0.05, logFC > 0) %>% pull(gene_name)
genes2.old <- genes.age$ColonTransverse$Age %>% filter(adj.P.Val < 0.05, logFC > 0) %>% pull(gene_name)
genes.old <- union(genes1.old, genes2.old)

# Collect genes that decrease with age (up in young)
genes1.young <- genes.age$ColonSigmoid$Age %>% filter(adj.P.Val < 0.05, logFC < 0) %>% pull(gene_name)
genes2.young <- genes.age$ColonTransverse$Age %>% filter(adj.P.Val < 0.05, logFC < 0) %>% pull(gene_name)
genes.young <- union(genes1.young, genes2.young)

# load DEG list 
save_path = paste0(proj.path, "/EOCRC_pseudobulk/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated/")
files = list.files(save_path)
files = files[grep("*AgeScaled__MSS_sideTherapySexStageCov_09-19-25_1pctExpressed_contScaleAge_YOCRC_filtered.csv", files)]

all_pos_degs = c()
all_neg_degs = c()
for (i in files){
  tmp = gsub("DESeq2_cluster_", "", i)
  tmp = gsub("_AgeScaled__MSS_sideTherapySexStageCov_09-19-25_1pctExpressed_contScaleAge_YOCRC_filtered.csv", "", i)
  print(tmp)
  degs = read.csv(paste0(save_path, i))
  neg = degs$X[degs$log2FoldChange<0]
  pos = degs$X[degs$log2FoldChange>0]
  
  all_neg_degs = c(all_neg_degs, neg)
  all_pos_degs = c(all_pos_degs, pos)
  
  if (length(neg)>0){
    degs_neg_gtex_young = intersect(neg, genes.young)
    print("neg FC in gtex young")
    print(degs_neg_gtex_young)
  }
  
  if (length(pos)>0){
    degs_pos_gtex_old = intersect(pos, genes.old)
    print("pos FC in gtex old")
    print(degs_pos_gtex_old)
  }
}

all_neg_degs = unique(all_neg_degs)
all_pos_degs = unique(all_pos_degs)

# Volcano plot for SIGMOID COLON 
# calculate overlapping genes from sigmoid colon 
overlapping_neg.sigm = intersect(genes1.young, all_neg_degs)
overlapping_pos.sigm = intersect(genes1.old, all_pos_degs)

# Enhanced volcano with overlapping DEGs labeled 
xlim_vals <- c(min(genes.age$ColonSigmoid$Age$logFC, na.rm = TRUE) - 0.01, max(genes.age$ColonSigmoid$Age$logFC, na.rm = TRUE) + 0.01)
ylim_vals <- c(0, max(-log10(genes.age$ColonSigmoid$Age$adj.P.Val), na.rm = TRUE) + 1)

EnhancedVolcano(
  genes.age$ColonSigmoid$Age,
  lab = genes.age$ColonSigmoid$Age$gene_name,
  x = 'logFC',
  y = 'adj.P.Val',
  pCutoff = 0.05,
  FCcutoff = 0,
  max.overlaps = 100,
  pointSize = 5,
  drawConnectors = TRUE,
  typeConnectors = "open", 
  xlim = xlim_vals,
  ylim = ylim_vals, 
  title="GTEx Aging - Sigmoid Colon", 
  selectLab = c(overlapping_neg.sigm, overlapping_pos.sigm))
ggsave(paste0(proj.path, '/GTEX/GTEx_Aging_Signmoid.pdf'), height=8, width=8))
ggsave(paste0(proj.path, '/GTEX/GTEx_Aging_Signmoid.png'), height=8, width=8, dpi=600)

# Volcano plot for TRANSVERSE COLON 
# calculate overlapping genes from sigmoid colon 
overlapping_neg.trans = intersect(genes2.young, all_neg_degs)
overlapping_pos.trans = intersect(genes2.old, all_pos_degs)

# Enhanced volcano with overlapping DEGs labeled 
xlim_vals <- c(min(genes.age$ColonTransverse$Age$logFC, na.rm = TRUE) - 0.01, max(genes.age$ColonTransverse$Age$logFC, na.rm = TRUE) + 0.01)
ylim_vals <- c(0, max(-log10(genes.age$ColonTransverse$Age$adj.P.Val), na.rm = TRUE) + 1)

EnhancedVolcano(
  genes.age$ColonTransverse$Age,
  lab = genes.age$ColonTransverse$Age$gene_name,
  x = 'logFC',
  y = 'adj.P.Val',
  pCutoff = 0.05,
  FCcutoff = 0,
  max.overlaps = 100,
  pointSize = 5,
  drawConnectors = TRUE,
  typeConnectors = "open", 
  xlim = xlim_vals,
  ylim = ylim_vals, 
  title="GTEx Aging - Transverse Colon", 
  selectLab = c(overlapping_neg.trans, overlapping_pos.trans))
ggsave(paste0(proj.path, '/GTEX/GTEx_Aging_Transverse.pdf'), height=8, width=8)
ggsave(paste0(proj.path, '/GTEX/GTEx_Aging_Transverse.png'), height=8, width=8, dpi=600)
