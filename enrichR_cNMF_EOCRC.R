# run EnrichR
rm(list=ls())
library(clusterProfiler)
library(org.Hs.eg.db)  # human gene annotation
library(msigdbr)
library(fgsea)

save_path = "/Volumes/broad_kco/projects/YOCRC/results/atlas_remake_June_20_2025/2025_07_29_YOCRC_cNMF/"

#collect genes from all csv files in the folder 
file_list = list(
  aocrc  = read.csv(paste0(save_path, 'topgenes_FiftyPlus_GEP_consensus.csv'), row.names = 1),
  eocrc = read.csv(paste0(save_path, 'topgenes_UnderFifty_GEP_consensus.csv'), row.names = 1)
)

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

  for (fname in names(file_list)){
    dat = file_list[[fname]]
    for (col in colnames(dat)){
      print(paste(fname, col))
      genes = dat[[col]]
      genes = genes[!is.na(genes) & genes != ""]
      
      msig_res <- enricher(
        gene          = genes,
        TERM2GENE     = m_df[, c("gs_name", "gene_symbol")],
        pAdjustMethod = "BH",
        pvalueCutoff  = 0.2,
      )
    
      write.csv(msig_res@result, paste0(save_path, "/PathwayAnalysis/", fname, "_", col, "_msig_", run$collection[r], "-", run$subcollection[r], "_results.csv"))
      if (sum(msig_res@result$p.adjust <= 0.2) > 0){
        pdf(paste0(save_path, "/TEST/", fname, "_", col, "_msig_", run$collection[r], "-", run$subcollection[r], "_barplot.pdf"), width = 8, height = 12)
        print(barplot(msig_res, showCategory = 15))
        dev.off()
      }
    }
  }
}
