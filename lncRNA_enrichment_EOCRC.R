# run EnrichR
rm(list=ls())
library(clusterProfiler)
library(org.Hs.eg.db)  # human gene annotation
library(msigdbr)
library(fgsea)
library(ggplot2)
library(tidyr)
library(dplyr)

save_path = "/home/EOCRC/EOCRC_pseudobulk/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated/"

#collect genes from all csv files in the folder 
files = list.files(save_path)
files = files[grep("*AgeScaled__MSS_sideTherapySexStageCov_09-19-25_1pctExpressed_contScaleAge_YOCRC.csv", files)] 

# looking for lncRNA enrichment 
library(biomaRt)
ensembl <- useEnsembl(biomart="genes", dataset="hsapiens_gene_ensembl")
lncRNA_genes <- getBM(
  attributes=c("hgnc_symbol", "gene_biotype"),
  filters="biotype",
  values="lncRNA",
  mart=ensembl)
lncRNA_symbols <- lncRNA_genes$hgnc_symbol

pos_p = data.frame(celltype=NA, pvalue=NA)
neg_p = data.frame(celltype=NA, pvalue=NA)
for (i in files){
  tmp = gsub("DESeq2_cluster_", "", i)
  tmp = gsub("_AgeScaled__MSS_sideTherapySexStageCov_09-19-25_1pctExpressed_contScaleAge_YOCRC.csv", "", i)
  print(tmp)
  degs = read.csv(paste0(save_path, i))
  A_genes = grep("^A.*\\.\\d+$", degs$X, value = TRUE)
  all_lncRNA = unique(c(lncRNA_symbols, A_genes))
  
  background <- degs[!is.na(degs$pvalue), ]
  lncRNA_background = intersect(background$X, all_lncRNA)

  degs_sig <- subset(degs, !is.na(padj) & padj < 0.05)
  
  if (length(degs_sig$X)>0){
    degs_neg <- subset(degs_sig, log2FoldChange < 0)
    degs_pos <- subset(degs_sig, log2FoldChange > 0)
    
    # negative 
    print("testing negative genes...")
    lncRNA_degs = intersect(degs_neg$X, all_lncRNA)

    a = length(lncRNA_degs)                         # DE & lncRNA
    b = length(degs_neg$X) - a                      # DE & NOT lncRNA
    c = length(lncRNA_background) - a               # NOT DE & lncRNA
    d = length(background$X) - (a + b + c)          # NOT DE & NOT lncRNA
    
    # Matrix construction (by column)
    # Column 1: lncRNAs (DE, then non-DE)
    # Column 2: others (DE, then non-DE)
    mat <- matrix(c(a, c, b, d), nrow=2,
                  dimnames=list(Is_DEG=c("Yes","No"), 
                                Is_lncRNA=c("Yes","No")))
    
    print(mat) 
    ft = fisher.test(mat)
    print(paste0("pvalue ", ft$p.value))
    print(paste0("or ", ft$estimate))
    neg_p = rbind(neg_p, data.frame(celltype=tmp, pvalue=ft$p.value))
    
    # positive 
    print("testing positive genes...")
    lncRNA_degs = intersect(degs_pos$X, all_lncRNA)
    
    # Contingency table
    a = length(lncRNA_degs)                          # DE lncRNAs
    b = length(degs_pos$X) - a                       # DE non-lncRNAs
    c = length(lncRNA_background) - a                # non-DE lncRNAs
    d = length(background$X) - (a + b + c)           # non-DE non-lncRNAs
    
    # Matrix construction (by column)
    # Column 1: lncRNAs (DE, then non-DE)
    # Column 2: others (DE, then non-DE)
    mat <- matrix(c(a, c, b, d), nrow=2,
                  dimnames=list(Is_DEG=c("Yes","No"), 
                                Is_lncRNA=c("Yes","No")))
    print(mat) 
    ft = fisher.test(mat)
    print(paste0("pvalue ", ft$p.value))
    print(paste0("or ", ft$estimate))
    pos_p = rbind(pos_p, data.frame(celltype=tmp, pvalue=ft$p.value))
    
  }
}

neg_p = neg_p[!is.na(neg_p$celltype),]
neg_p$FDR = p.adjust(neg_p$pvalue, method="fdr")

pos_p = pos_p[!is.na(pos_p$celltype),]
pos_p$FDR = p.adjust(pos_p$pvalue, method="fdr")


# Make a bar plot showing the proportion of lncRNAs in main figure cell types 
to_plot = c(4, 10, 16, 20)
for (t in to_plot){
  i = files[t]
  tmp = gsub("DESeq2_cluster_", "", i)
  tmp = gsub("_AgeScaled__MSS_sideTherapyCov_09-19-25_1pctExpressed_contScaleAge_YOCRC.csv", "", i)
  print(tmp)
  degs = read.csv(paste0(save_path, i))
  A_genes = grep("^A.*\\.\\d+$", degs$X, value = TRUE)
  all_lncRNA = unique(c(lncRNA_symbols, A_genes))
  
  degs_sig <- subset(degs, !is.na(padj) & padj < 0.05)
  degs_neg <- subset(degs_sig, log2FoldChange < 0)
  degs_pos <- subset(degs_sig, log2FoldChange > 0)
  
  lncRNA_degs_neg = intersect(degs_neg$X, all_lncRNA)
  lncRNA_degs_pos = intersect(degs_pos$X, all_lncRNA)
  
  neg_lnc = length(lncRNA_degs_neg)
  pos_lnc = length(lncRNA_degs_pos)
  neg_other = length(degs_neg$X)-neg_lnc
  pos_other = length(degs_pos$X)-pos_lnc
  
  df = data.frame(neg = c(neg_other, neg_lnc), pos = c(pos_other, pos_lnc))
  df$type = c("not-lncNRA", "lncRNA")
  colnames(df) = c("High in EO-CRC", "High in AO-CRC", "type")
  
  df_long <- pivot_longer(df,
                          cols = c("High in EO-CRC", "High in AO-CRC"),
                          names_to = "class",
                          values_to = "count")
  df_long$class <- factor(df_long$class,
                          levels = c("High in EO-CRC", "High in AO-CRC"))
  
  p=ggplot(df_long, aes(x = class, y = count, fill = type)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(x = "", 
         y = "DEG Proportion",
         fill = "Gene Type",
         title = "lncRNA Representation") +
    theme_minimal() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  print(p)
  ggsave(paste0(save_path, "lncRNA_proportion_", tmp, ".pdf"),  width = 3, height = 4)
}
