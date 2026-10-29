library(tximport)
library(DESeq2)
library(ggplot2)
library(ggrepel)
library(TCGAbiolinks)
library(SummarizedExperiment)
library(openxlsx)
library(dplyr)


#'[ Get RNAseq data from GDC - COAD and READ
# Includes MSI status from:
#   coad subtype information from: doi:10.1038/nature11252
#   read subtype information from: doi:10.1038/nature11252

query <- GDCquery(project = c("TCGA-COAD", "TCGA-READ"),
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  experimental.strategy = "RNA-Seq",
                  workflow.type = "STAR - Counts",
                  access = "open")

# # Download data to local directory using the query in 50 file chunks
# GDCdownload(query = query, method = "api", files.per.chunk = 50, directory = "C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/GDC_files/")

# Import data as R object (SummarizedExperiment)
tcga <- GDCprepare(query,
                   directory = "C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/GDC_files/")

#'[ Format TCGA metadata

# Isolate metadata
tcga_meta <- as.data.frame(tcga@colData)

# # Use age_at_index? YES
# # Check that it corresponds to age_at_diagnosis converted to years - TRUE
# age <- tcga_meta[,c('age_at_diagnosis', 'age_at_index')]
# age_na <- age[!complete.cases(age),]
# age <- age[complete.cases(age),]
# age$age_diag <- floor(age$age_at_diagnosis/365.25)
# age2 <- age[age$age_at_index != age$age_diag,]
# all(age$age_at_index == age$age_diag)
# any(age$age_at_index != age$age_diag)

# Select and rename columns of interest
tcga_meta <- tcga_meta[,c('barcode', 'project_id', 'age_at_index', 'gender',
                          'ajcc_pathologic_stage','site_of_resection_or_biopsy',
                          'prior_treatment', 'sample_type', 'sample')]
colnames(tcga_meta) <- c('Barcode', 'Cohort', 'Age', 'Sex', 'Stage', 'Side',
                         'Treatment', 'Sample_type', 'Submitter_id')

# Get sample ID (Before 3rd dash in Barcode)
tcga_meta$Sample_id <- sub("([^-]*-[^-]*-[^-]*)-.*", "\\1", tcga_meta$Barcode)

tcga_meta <- tcga_meta %>%
  mutate(Sex = case_when(Sex == 'male' ~ 'Male',
                         Sex == 'female' ~ 'Female',
                         Sex == 'not reported' ~ 'Unknown',
                         TRUE ~ Sex),
         Stage = case_when(Stage %in% c('Stage I','Stage IA') ~ '1',
                           Stage %in% c('Stage II','Stage IIA',
                                        'Stage IIB','Stage IIC') ~ '2',
                           Stage %in% c('Stage III', 'Stage IIIA',
                                        'Stage IIIB','Stage IIIC') ~ '3',
                           Stage %in% c('Stage IV','Stage IVA','Stage IVB') ~ '4',
                           TRUE ~ Stage),
         Side = case_when(Side %in% c('Cecum', 'Ascending colon',
                                      'Hepatic flexure of colon',
                                      'Transverse colon',
                                      'Splenic flexure of colon') ~ 'Right',
                          Side %in% c('Descending colon', 'Sigmoid colon',
                                      'Rectosigmoid junction') ~ 'Left',
                          Side %in% c('Rectum, NOS') ~ 'Rectal',
                          TRUE ~ Side),
         Onset = ifelse(Age < 50, 'Early', 'Average'),
         Cohort = 'TCGA')

#' #'[ Get MSI data from paper
#' # Liu Y, Sethi NS, Hinoue T, et al.
#' # Comparative Molecular Analysis of Gastrointestinal Adenocarcinomas.
#' # Cancer Cell. 2018;33(4):721-735.e8. doi:10.1016/j.ccell.2018.03.010
#' # Table S1 or https://github.com/KatherLab/cancer-metadata/blob/main/tcga/liu.xlsx
#' 
#' paper_meta <- read.xlsx('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/data/liu.xlsx')
#' paper_meta <- paper_meta[paper_meta$TCGA.Project.Code %in% c('COAD', 'READ'),]
#' paper_msi_low <- paper_meta[paper_meta$MSI.Status %in% c('MSI-L'),]$TCGA.Participant.Barcode
#' paper_msi_high <- paper_meta[paper_meta$MSI.Status %in% c('MSI-H'),]$TCGA.Participant.Barcode
#' paper_mss <- paper_meta[paper_meta$MSI.Status %in% c('MSS'),]$TCGA.Participant.Barcode
#' 
#' # Test out the difference between paper and GDC statuses
#' tcga_meta$Paper_MSI <- NA
#' tcga_meta[tcga_meta$Sample_id %in% paper_msi_low,]$Paper_MSI <- 'MSS'
#' tcga_meta[tcga_meta$Sample_id %in% paper_msi_high,]$Paper_MSI <- 'MSI'
#' tcga_meta[tcga_meta$Sample_id %in% paper_mss,]$Paper_MSI <- 'MSS'
#' 
#' tbl <- table(tcga_meta$MSI_status, tcga_meta$Paper_MSI, useNA='always')
#' print(tbl)


#'[ Get TCGA MSI data directly from GDC portal
# Create cohort (TCGA-COAD and TCGA-READ) in cohort builder tab
# In repository tab
#     Add custom filter -> msi_status
#     Click MSS (selects 1,106 files from 545 cases)
#     Download Sample sheet and get unique cases listed.

#'@_PROBLEM
# Some samples IDs have files/BAMs listed as both MSS and MSI
# Seems to be due to different releases/versions/plates
#'@_Solution
# Go through the files for samples with both -- manually in the GDC portal
# Get MSI status listed for the highest/latest portion/plate/barcode
# Also check analyte type to prioritize D over G/W/X

# Get samples with MSS files/BAMs
mss <- read.table('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/data/gdc_sample_sheet.2026-03-05.COADREAD_MSS.tsv',
                  sep='\t', header=T)
mss <- mss[mss$Sample.ID %in% tcga_meta$Submitter_id,]
mss <- data.frame(Submitter_id = unique(mss$Sample.ID), MSI_status = 'MSS')

# Get samples with MSI files/BAMs
msi <- read.table('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/data/gdc_sample_sheet.2026-03-05.COADREAD_MSI.tsv',
                  sep='\t', header=T)
msi <- msi[msi$Sample.ID %in% tcga_meta$Submitter_id,]
msi <- data.frame(Submitter_id = unique(msi$Sample.ID), MSI_status = 'MSI')

# Manual check if some samples have both
msi_status <- rbind(mss,msi)
msi_status_dup <- msi_status[duplicated(msi_status$Submitter_id) |
                               duplicated(msi_status$Submitter_id, fromLast=T),]
tcga_meta_msi <- merge(tcga_meta, msi_status, on='Submitter_id', all.x=T)
tcga_meta_dup <- tcga_meta_msi[duplicated(tcga_meta_msi$Barcode) |
                                 duplicated(tcga_meta_msi$Barcode, fromLast=T),]
print(table(tcga_meta_dup$Submitter_id))

# Add MSI_status column
tcga_meta$MSI_status <- 'Unknown'
# Add status using presence of MSS/MSI files
tcga_meta[tcga_meta$Submitter_id %in% mss$Submitter_id,]$MSI_status <- 'MSS'
tcga_meta[tcga_meta$Submitter_id %in% msi$Submitter_id,]$MSI_status <- 'MSI'

# For samples with files in both MSS and MSI, use manually checked status
manual_mss <- c('TCGA-A6-2680-01A', 'TCGA-A6-2683-01A', 'TCGA-A6-6650-01A',
                'TCGA-AA-A00U-01A', 'TCGA-AG-3892-01A', 'TCGA-AG-A008-01A',
                'TCGA-AZ-4616-01A', 'TCGA-CM-6168-01A', 'TCGA-F4-6703-01A',
                'TCGA-G4-6302-01A', 'TCGA-G4-6304-01A')
manual_msi <- c('TCGA-AA-A01G-01A', 'TCGA-AA-A01P-01A', 'TCGA-AA-A01R-01A',
                'TCGA-AG-A00C-01A', 'TCGA-AG-A015-01A')
tcga_meta[tcga_meta$Submitter_id %in% manual_mss,]$MSI_status <- 'MSS'
tcga_meta[tcga_meta$Submitter_id %in% manual_msi,]$MSI_status <- 'MSI'

# Order columns
tcga_meta <- tcga_meta[,c('Sample_id', 'Barcode', 'Cohort', 'Age', 'Sex',
                          'Stage', 'Side', 'Treatment', 'Sample_type',
                          'Onset', 'MSI_status')]

#'[ Save/Load data

#save.image('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous/Loaded_TCGA_data.Rdata')
load('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous/Loaded_TCGA_data.Rdata')

#'[ Subset metadata based on covariates of interest

#'* Set which version of age to use *
a <- 'Age_scaled'

#'* Set covariates to include (Sex, Side only ones relevant to normal) *
candidate_covars <- c('Side', 'Sex')

#'* Choose if prefiltering is happening or not *
filtering <- 'Filtering.Pre.Ind'
#filtering <- 'Filtering.Ind'

#'* Choose significance threshold * 
#alpha <- 0.05
alpha <- 0.1

# # Subset meta
# meta <- tcga_meta[tcga_meta$Sample_type == 'Primary Tumor' & 
#                     !is.na(tcga_meta$Age) &
#                     tcga_meta$MSI_status %in% c('MSS', 'MSI-L') &
#                     tcga_meta$Treatment %in% c('Yes', 'No') &
#                     tcga_meta$Side %in% c('Right', 'Left', 'Rectal') &
#                     tcga_meta$Sex %in% c('Female', 'Male') &
#                     tcga_meta$Stage %in% c('1', '2', '3', '4'),]

meta <- tcga_meta

# Keep only Normal samples with Age data (51 samples)
meta <- meta[(meta$Sample_type == 'Solid Tissue Normal'),]
meta <- meta[!is.na(meta$Age),]
meta$Age_scaled <- as.numeric(scale(meta$Age))

# # Keep MSS/MSI-L samples only - not relevant to Normal samples
# meta <- meta[meta$MSI_status %in% c('MSS'),]

# Filter samples based on covariates included
if('Side' %in% candidate_covars){
  meta <- meta[meta$Side %in% c('Right', 'Left', 'Rectal'),]
}
if('Sex' %in% candidate_covars){
  meta <- meta[meta$Sex %in% c('Female', 'Male'),]
}

#'[ Filter out duplicate specimens

dups <- meta[duplicated(meta$Sample_id) |
               duplicated(meta$Sample_id, fromLast=T),]

# For each duplicated case, keep barcode with the highest lexicographical sort value
remove <- c()
for(id in unique(dups$Sample_id)){
  sub <- dups[dups$Sample_id == id,]
  sub <- sub[order(sub$Barcode, decreasing = T),]
  remove <- c(remove, sub[-1,]$Barcode)
}
meta <- meta[!(meta$Barcode %in% remove),]

print(paste('Any duplicated Sample_id?',
            any(duplicated(meta$Sample_id))))

#'[ Subset expression matrix and get tables for variables of interest

# Get and subset gene expression matrix
tcga_mat <- assay(tcga,"unstranded") 
tcga_mat <- tcga_mat[,meta$Barcode]

# Check that meta and matrix are in the same order
print(paste('Metadata and matrix in same order?',
            all(colnames(tcga_mat) == meta$Barcode)))

# Make all possible covariates into factors
meta$Cohort <- as.factor(meta$Cohort)
meta$Treatment <- as.factor(meta$Treatment)
meta$Side <- as.factor(meta$Side)
meta$Sex <- as.factor(meta$Sex)
meta$Stage <- as.factor(meta$Stage)
meta$Onset <- as.factor(meta$Onset)

# Print tables for all relevant variables
tbls <- list()
for(c in c('Sample_type', candidate_covars)){
  tbl <- as.data.frame(table(meta[[c]], useNA='always')) %>%
    mutate(Variable = c)
  tbls[[c]] <- tbl
  
  cat(paste('\n', c))
  print(tbl)
}
tbls <- bind_rows(tbls)
tbls <- tbls[,c(3,1,2)]
colnames(tbls) <- c('Variable', 'Value', 'Count')

#'[ Make DESeq2 design formula

# Check sparsity of covariates
min_per_level = 2
valid_covars <- c()
for (v in candidate_covars) {
  tbl <- table(meta[[v]])
  if (length(tbl) > 1 && min(tbl) >= min_per_level) {
    valid_covars <- c(valid_covars, v)
  }
}

# make design formula 
design_formula <- as.formula(paste('~',paste(valid_covars, collapse = " + "), ' + ', a))
print(paste0("Design formula: ", deparse(design_formula)))

#'[ Save filtered data

save(list = c('meta', 'query', 'tcga', 'tcga_mat', 'tcga_meta', 'design_formula',
              'a', 'candidate_covars', 'filtering', 'alpha', 'tbls', 'valid_covars'),
     file = 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_Normal/Filtered_TCGA_data.RData')

load('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_Normal/Filtered_TCGA_data.RData')

#'[ DESEQ2

dds <- DESeqDataSetFromMatrix(tcga_mat,
                              colData = meta,
                              design = design_formula)

# Filter genes with very low expression data
# From DESeq2 vignette:
# "Here we perform pre-filtering to keep only rows that have a count of
# at least 10 for a minimal number of samples. The count of 10 is a reasonable
# choice for bulk RNA-seq. A recommendation for the minimal number of samples
# is to specify the smallest group size, e.g. here there are 3 treated samples.
# If there are not discrete groups, one can use the minimal number of samples
# where non-zero counts would be considered interesting."
#'* Since age is continuous, we arbitrarily use 1% of the number of samples *
if(filtering == 'Filtering.Pre.Ind'){
  keep <- rowSums(counts(dds) >= 10) >= 5
  dds <- dds[keep,]
}

# Run Deseq 
dds <- DESeq(dds)

#'[ PCA

#' rld <- varianceStabilizingTransformation(dds, blind=FALSE)
#' DESeq2::plotPCA(rld, intgroup = "Cohort")
#' # ggsave(paste0('DESeq2_PCA_cluster_.png'), height=4, width=4)
#' 
#' #'* Method 2 - visualize transformed data with covariates adjusted *
#' # Get vst
#' vsd <- vst(dds, blind=FALSE)
#' # Remove variation 
#' mat <- assay(vsd)
#' mm <- model.matrix(~Age_scaled, colData(vsd))
#' covariates <- model.matrix(~Side + Sex + Stage + Cohort, data=meta)[,-1]
#' mat <- limma::removeBatchEffect(mat, covariates = covariates, design=mm)
#' assay(vsd) <- mat
#' DESeq2::plotPCA(vsd, intgroup = "Cohort")


#'[ Get Results

print(resultsNames(dds))

# Get results
# Specify cutoff threshold for independent filtering
res <- results(dds, name=a, alpha=alpha)

# Get mapping from gene ID to symbol from tcga biolinks object
mapping <- as.data.frame(rowData(tcga))
mapping <- mapping[,c('gene_id', 'gene_type', 'gene_name')]

# Map gene id to gene name with original mapping gotten from counts file
res$gene_id <- rownames(res)
res <- merge(as.data.frame(res), mapping, by='gene_id', all.x=T)

# Order results by padj value and reorder columns
res <- res[order(res$padj),][,c(1,8,9,2,3,4,5,6,7)]

# Keep only significant genes
res_sig <- res[res$padj < alpha,]

#'[ Save results 

info <- data.frame(Design = c(deparse(design_formula)))

de_results <- list("Metadata" = meta,
                   "Design" = info, "Variable_counts" = tbls,
                   "DE_results" = res, "DE_sig" = res_sig)
file_name <- paste0('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_Normal/DE_results/TCGA_Normal_',
                    a, '_DE_', paste(valid_covars, collapse = "."),
                    '.adjusted_', filtering, '.', alpha, '.xlsx')
write.xlsx(de_results, file = file_name)


#'[ Check overlap with all different cell type DEGs 

# sheets <- c('repeatDEGs', 'LGR5', 'MT-Ribo-hi Epi', 'CEACAM', 'MUC2',
#             'Enteroendocrine','Fibroblast', 'Fibroblast-BMP-SOX6',
#             'Fibroblast-Infl', 'Fibroblast-MMP2-THY1', 'Macrophage-monocyte',
#             'Neutrophil', 'Cycling Myeloid', 'DC', 'Glial', 'MT-Ribo-hi Stromal')

sheets <- getSheetNames('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated.xlsx')
#sheets <- sheets[1]
for(s in sheets){
  print(s)
  
  DEGs <- read.xlsx('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated.xlsx',
                    sheet=s)
  
  res_overlap <- res[res$gene_name %in% DEGs$Gene,]
  
  # Add if FC directionality matches
  res_overlap$Direction_match <- TRUE
  for(g in res_overlap$gene_name){
    # Get sign of bulk fold change
    bulk_sign <- sign(res_overlap[res_overlap$gene_name == g,]$log2FoldChange)
    
    if(s == 'repeatDEGs'){
      # Positive = FALSE, Negative = TRUE
      if(bulk_sign == 1){bulk_sign <- F}
      if(bulk_sign == -1){bulk_sign <- T}
      
      # TRUE if sc fold change contains a minus (-)
      sc_sign <- DEGs[DEGs$Gene == g,]$FC
      sc_sign <- grepl('-', sc_sign, fixed=T)
    } else {
      sc_sign <- sign(DEGs[DEGs$Gene == g,]$log2FoldChange)
    }
    
    
    # If signs disagree, update df
    if(bulk_sign != sc_sign){
      res_overlap[res_overlap$gene_name == g,]$Direction_match <- FALSE
    }
  }
  
  res_sig_overlap <- res_overlap[res_overlap$padj < alpha,]
  
  # Add sheet to existing excel result file
  wb <- loadWorkbook(file_name)
  addWorksheet(wb, s)
  writeData(wb, sheet = s, x = res_sig_overlap)
  saveWorkbook(wb, file_name, overwrite = TRUE)
  
}