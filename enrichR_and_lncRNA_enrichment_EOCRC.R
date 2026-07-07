# run EnrichR
rm(list=ls())
library(clusterProfiler)
library(org.Hs.eg.db)  # human gene annotation
library(msigdbr)
library(fgsea)

save_path = "/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/09-19-25_YOCRC_pseudobulk/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated/"

#collect genes from all csv files in the folder 
files = list.files(save_path)
files = files[grep("*AgeScaled__MSS_sideTherapyCov_09-19-25_1pctExpressed_contScaleAge_YOCRC.csv", files)] # need to rerun to get updated file names

# # find overall background for repeat DEGs list 
# genes = c()
# for (i in files){
#   tmp = read.csv(paste0("/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/09-19-25_YOCRC_pseudobulk/pseudobulk_DEG_results_MSSonly_sideTherapyCov_1pctExpressed_contAge_09-19-2025/", i))
#   genes = c(genes, tmp$X)
# }
# background_all = unique(genes)

# load msigdb hallmark 
# 1 C1            ""                "Positional"                                    302
# 2 C2            "CGP"             "Chemical and Genetic Perturbations"           3538
# 3 C2            "CP"              "Canonical Pathways"                             19
# 4 C2            "CP:BIOCARTA"     "BioCarta Pathways"                             292
# 5 C2            "CP:KEGG_LEGACY"  "KEGG Legacy Pathways"                          186
# 6 C2            "CP:KEGG_MEDICUS" "KEGG Medicus Pathways"                         658
# 7 C2            "CP:PID"          "PID Pathways"                                  196
# 8 C2            "CP:REACTOME"     "Reactome Pathways"                            1787
# 9 C2            "CP:WIKIPATHWAYS" "WikiPathways"                                  885
# 10 C3            "MIR:MIRDB"       "miRDB"                                        2377
# 11 C3            "MIR:MIR_LEGACY"  "MIR_Legacy"                                    221
# 12 C3            "TFT:GTRD"        "GTRD"                                          505
# 13 C3            "TFT:TFT_LEGACY"  "TFT_Legacy"                                    610
# 14 C4            "3CA"             "Curated Cancer Cell Atlas gene sets "          148
# 15 C4            "CGN"             "Cancer Gene Neighborhoods"                     427
# 16 C4            "CM"              "Cancer Modules"                                431
# 17 C5            "GO:BP"           "GO Biological Process"                        7583
# 18 C5            "GO:CC"           "GO Cellular Component"                        1042
# 19 C5            "GO:MF"           "GO Molecular Function"                        1855
# 20 C5            "HPO"             "Human Phenotype Ontology"                     5748
# 21 C6            ""                "Oncogenic Signature"                           189
# 22 C7            "IMMUNESIGDB"     "ImmuneSigDB"                                  4872
# 23 C7            "VAX"             "HIPC Vaccine Response"                         347
# 24 C8            ""                "Cell Type Signature"                           866
# 25 H             ""                "Hallmark"                                       50

run = data.frame(collection = c("H", "C2", "C2", "C2", "C4", "C4", "C4", "C5", "C5", "C6", "C7"),
                 subcollection = c(NA, "CP:REACTOME", "CP:KEGG_LEGACY", "CP:WIKIPATHWAYS", "3CA", "CGN", "CM", "GO:BP", "GO:MF", NA, "IMMUNESIGDB"))

for (r in 1:nrow(run)){
  print(r)
  if (is.na(run$subcollection[r])) {
    m_df <- msigdbr(species = "Homo sapiens", collection = run$collection[r])
  } else {   
    m_df <- msigdbr(species = "Homo sapiens", collection = run$collection[r], subcollection = run$subcollection[r])
  }

  for (i in files){
    tmp = gsub("DESeq2_cluster_", "", i)
    tmp = gsub("_Age__MSS_sideTherapyCov_09-19-25_1pctExpressed_contAge_YOCRC.csv", "", i)
    print(tmp)
    degs = read.csv(paste0(save_path, i))
    degs_sig <- subset(degs, !is.na(padj) & padj < 0.05)
    degs_neg <- subset(degs_sig, log2FoldChange < 0)
    degs_pos <- subset(degs_sig, log2FoldChange > 0)
    background <- degs[!is.na(degs$pvalue), ]
    
    if (length(degs_neg$X)>9){
      msig_neg <- enricher(
        gene          = degs_neg$X,     # DE genes (symbols)
        universe      = background$X,   # background (symbols)
        TERM2GENE     = m_df[, c("gs_name", "gene_symbol")],
        pAdjustMethod = "BH", 
        pvalueCutoff = 0.2,
      )
      write.csv(msig_neg@result, paste0(save_path, "/PathwayAnalysis/", tmp, "_msig_", run$collection[r], "-", run$subcollection[r], "_negFC_results.csv"))
      if (sum(msig_neg@result$p.adjust<=0.2)>0){
        pdf(paste0(save_path, "/PathwayAnalysis/", tmp, "_msig_", run$collection[r], "-", run$subcollection[r], "_negFC_barplot.pdf"), width = 8, height = 12)
        print(barplot(msig_neg, showCategory = 15))
        dev.off()
      }
    }
    
    if (length(degs_pos$X)>9){
      msig_pos <- enricher(
        gene          = degs_pos$X,     # your sig genes (symbols)
        universe      = background$X,   # optional background (symbols)
        TERM2GENE     = m_df[, c("gs_name", "gene_symbol")],
        pAdjustMethod = "BH", 
        pvalueCutoff = 0.2,
      )
      write.csv(msig_pos@result, paste0(save_path, "/PathwayAnalysis/", tmp, "_msig_", run$collection[r], "-", run$subcollection[r], "_posFC_results.csv"))
      if (sum(msig_pos@result$p.adjust<=0.2)>0){
        pdf(paste0(save_path, "/PathwayAnalysis/", tmp, "_msig_", run$collection[r], "-", run$subcollection[r], "_posFC_barplot.pdf"), width = 8, height = 12)
        print(barplot(msig_pos, showCategory = 15))
        dev.off()
      }
    }
  }  
}

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
  tmp = gsub("_AgeScaled__MSS_sideTherapyCov_09-19-25_1pctExpressed_contScaleAge_YOCRC.csv", "", i)
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


# Make a bar plot showing the proportion of lncRNAs in LGR5+ and Fibroblast 
# LGR5 
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
  
  library(ggplot2)
  library(tidyr)
  library(dplyr)
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
  #ggsave(paste0(save_path, "lncRNA_proportion_", tmp, ".pdf"),  width = 3, height = 4)
}


# make a list of LGR5+ lncrnas 
i = files[16]
tmp = gsub("DESeq2_cluster_", "", i)
tmp = gsub("_AgeScaled__MSS_sideTherapyCov_09-19-25_1pctExpressed_contScaleAge_YOCRC.csv", "", i)
print(tmp)
degs = read.csv(paste0(save_path, i))
A_genes = grep("^A.*\\.\\d+$", degs$X, value = TRUE)
all_lncRNA = unique(c(lncRNA_symbols, A_genes))

degs_sig <- subset(degs, !is.na(padj) & padj < 0.05)
degs_neg <- subset(degs_sig, log2FoldChange < 0)
lncRNA_degs_neg = intersect(degs_neg$X, all_lncRNA)

# check for lncRNA enrichment in TCGA bulk results 
library(openxlsx)
#tcga_res = read.xlsx('/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/TCGA_MSS_Age_scaled_DE_Side_Sex_Stage_adjusted.xlsx', sheet='DE_results')
tcga_res = read.xlsx('/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/TCGA_YOCRC_MSS_Age_scaled_DE_Treatment.Side.Sex.Stage.Cohort.adjusted_Filtering.Pre.Ind.0.1.xlsx', sheet='DE_results')
# tcga_res = read.xlsx('/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/TCGA_YOCRC_MSS_Age_scaled_DE_Treatment.Side.Sex.Stage.Cohort.adjusted_Filtering.Pre.Ind.0.05.xlsx', sheet="DE_results")
#tcga_res = read.xlsx('/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/TCGA_YOCRC_MSS_Age_scaled_No_Treatment_DE_Side.Sex.Stage.Cohort.adjusted_Filtering.Pre.Ind.0.1.xlsx', sheet="DE_results")
#tcga_res = read.xlsx('/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/TCGA_MSS_Age_scaled_DE_Side.Sex.Stage.adjusted_Filtering.Ind_03-05-26.xlsx', sheet="DE_results")
#tcga_res = read.xlsx('/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/TCGA_YOCRC_MSS_Age_scaled_DE_Side.Sex.Stage.Cohort.adjusted_Filtering.Ind_03-05-26.xlsx', sheet="DE_results")

summary(tcga_res$log2FoldChange[tcga_res$padj < 0.1])

study_biotypes <- c("protein_coding", "lncRNA")
universe_df <- tcga_res[!is.na(tcga_res$padj) & 
                          tcga_res$gene_type %in% study_biotypes, ]

is_deg_neg <- universe_df$padj < 0.1 & universe_df$log2FoldChange < -0.15
is_deg_pos <- universe_df$padj < 0.1 & universe_df$log2FoldChange > 0.15
is_lncRNA  <- universe_df$gene_type == "lncRNA"

# Counts
a = sum(is_deg_neg & is_lncRNA)                # DE lncRNAs
b = sum(is_deg_neg & !is_lncRNA)               # DE protein-coding
c = sum(!is_deg_neg & is_lncRNA)               # Non-DE lncRNAs
d = sum(!is_deg_neg & !is_lncRNA)              # Non-DE protein-coding

sum(a+b+c+d)==nrow(universe_df)

mat <- matrix(c(a, b, c, d), nrow = 2,
              dimnames = list(Type   = c("lncRNA", "Other"),
                              Status = c("DEG_Neg", "Not_DEG")))

ft <- fisher.test(mat)
print(mat)
cat("P-value:", ft$p.value, "\n")
cat("Odds Ratio:", ft$estimate, "\n")

# Counts
a = sum(is_deg_pos & is_lncRNA)                # DE lncRNAs
b = sum(is_deg_pos & !is_lncRNA)               # DE protein-coding
c = sum(!is_deg_pos & is_lncRNA)               # Non-DE lncRNAs
d = sum(!is_deg_pos & !is_lncRNA)              # Non-DE protein-coding

sum(a+b+c+d)==nrow(universe_df)

mat <- matrix(c(a, b, c, d), nrow = 2,
              dimnames = list(Type   = c("lncRNA", "Other"),
                              Status = c("DEG_Pos", "Not_DEG")))

ft <- fisher.test(mat)
print(mat)
cat("P-value:", ft$p.value, "\n")
cat("Odds Ratio:", ft$estimate, "\n")



