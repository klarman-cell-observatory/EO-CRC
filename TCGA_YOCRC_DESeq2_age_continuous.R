library(tximport)
library(DESeq2)
library(ggplot2)
library(ggrepel)
library(TCGAbiolinks)
library(SummarizedExperiment)
library(openxlsx)
library(dplyr)
library(biomaRt)


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

# Download data to local directory using the query in 50 file chunks
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
                          Side %in% c('Descending colon', 'Sigmoid colon') ~ 'Left',
                          Side %in% c('Rectum, NOS',
                                      'Rectosigmoid junction') ~ 'Rectal',
                          TRUE ~ Side),
         Onset = ifelse(Age < 50, 'Early', 'Average'),
         Cohort = 'TCGA')

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

#'[ Get YOCRC STAR counts and metadata

# Import unstranded counts matrix
yocrc_mat <- read.table('C:/Users/jcazaubiel/Documents/YOCRC/STAR_2.7.5c/Count_matrix/YOCRC_STAR_counts_unstranded.tsv',
                        sep='\t', row.names=1, header=T, check.names = F)

# Import metadata
yocrc_meta <- read.table('C:/Users/jcazaubiel/Documents/YOCRC/metadata/YOCRC_metadata_reviewed_v2.csv',
                         sep=',', header=T)

# Format metadata
colnames(yocrc_meta) <- c('Barcode', 'Sample_id', 'Stage', 'Age_at_dx',
                          'Age', 'Site', 'Sex',
                          'Race', 'Ethnicity', 'MSI_status',
                          'First_degree_CRC_family_history', 'BMI_at_dx', 'Treatment')

yocrc_meta <- yocrc_meta %>%
  mutate(MSI_status = case_when(MSI_status == 'High_instability' ~ 'MSI',
                                MSI_status == 'Stable' ~ 'MSS',
                                TRUE ~ MSI_status),
         Side = case_when(Site %in% c('Right', 'Transverse') ~ 'Right',
                          Site %in% c('Left') ~ 'Left',
                          Site %in% c('Rectal', 'Rectum',
                                      'Rectosigmoid') ~ 'Rectal',
                          TRUE ~ Site),
         Cohort = 'YOCRC',
         Sample_type = 'Primary Tumor',
         Onset = ifelse(Age < 50, 'Early', 'Average'))

yocrc_meta <- yocrc_meta[,c('Sample_id', 'Barcode', 'Cohort', 'Age', 'Sex',
                            'Stage', 'Side', 'Treatment', 'Sample_type',
                            'Onset', 'MSI_status')]

# Exclude samples (overlapped)
yocrc_meta <- yocrc_meta[!(yocrc_meta$Sample_id %in% c('COL00105', 'COL00132',
                                                       'COL00285', 'COL00315',
                                                       'COL00384', 'COL00572',
                                                       'COL00591', 'COL00612',
                                                       'COL00624')),]
# yocrc_meta <- yocrc_meta[yocrc_meta$Treatment != 'Overlap - to be excluded',]

#'[ Look a metadata demographics before filtering

# for(c in c('Cohort', 'Sample_type', 'MSI_status',
#            'Side', 'Sex', 'Stage', 'Treatment')){
#   cat(paste0('\n', c))
#   print(table(yocrc_meta[[c]], useNA='always'))
# }

#'[ Save/Load data

#save.image('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Loaded_TCGA_YOCRC.Rdata')
load('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Loaded_TCGA_YOCRC.Rdata')

#'[ Merge and subset metadata based on covariates of interest

#'* Set which version of age to use *
#a <- 'Age'
a <- 'Age_scaled'
#a <- 'Onset'

#'* Set covariates to include (Treatment, Side, Sex, Stage) *
candidate_covars <- c('Treatment', 'Side', 'Sex', 'Stage', 'Cohort')
#candidate_covars <- c('Treatment', 'Side')

#'* Choose if prefiltering is happening or not *
filtering <- 'Filtering.Pre.Ind'
#filtering <- 'Filtering.Ind'

#'* Choose significance threshold * 
#alpha <- 0.05
alpha <- 0.1

# Merge TCGA and YOCRC metadata
meta <- rbind(tcga_meta, yocrc_meta)

# Keep only primary tumors with age data
meta <- meta[(meta$Sample_type == 'Primary Tumor'),]
meta <- meta[!is.na(meta$Age),]
meta$Age_scaled <- as.numeric(scale(meta$Age))

# Keep MSS/MSI-L samples only
meta <- meta[meta$MSI_status %in% c('MSS'),]

# Filter samples based on covariates included
#'@_Treatment_YES/NO_or_just_NO
if('Treatment' %in% candidate_covars){
  meta <- meta[meta$Treatment %in% c('Yes', 'No'),]
  #meta <- meta[meta$Treatment %in% c('No'),]
}
if('Side' %in% candidate_covars){
  meta <- meta[meta$Side %in% c('Right', 'Left', 'Rectal'),]
}
if('Sex' %in% candidate_covars){
  meta <- meta[meta$Sex %in% c('Female', 'Male'),]
}
if('Stage' %in% candidate_covars){
  meta <- meta[meta$Stage %in% c('1', '2', '3', '4'),]
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

#'[ Look a metadata demographics after filtering

# meta_yocrc <- meta[meta$Cohort == 'YOCRC',]
# meta_tcga <- meta[meta$Cohort %in% c('TCGA-COAD', 'TCGA-READ'),]
# 
# for(c in c('Cohort', 'Sample_type', 'MSI_status',
#            'Side', 'Sex', 'Stage', 'Treatment')){
#   cat(paste0('\n', c))
#   print(table(meta_yocrc[[c]], useNA='always'))
# }

#'[ Subset expression matrix and get tables for variables of interest

# Get TCGA gene expression matrix
tcga_mat <- assay(tcga,"unstranded")

print(paste('Matrices in the same order:',
            all(row.names(tcga_mat) == row.names(yocrc_mat))))

# Merge matrices and subset based on metadata
mat <- cbind(tcga_mat, yocrc_mat)
mat <- mat[,meta$Barcode]

# Check that meta and matrix are in the same order
print(paste('Metadata and matrix in same order?',
            all(colnames(mat) == meta$Barcode)))

# Make metadata rownames match matrix colnames
rownames(meta) <- colnames(mat)

# Make all possible covariates into factors
meta$Cohort <- as.factor(meta$Cohort)
meta$Treatment <- as.factor(meta$Treatment)
meta$Side <- as.factor(meta$Side)
meta$Sex <- as.factor(meta$Sex)
meta$Stage <- as.factor(meta$Stage)
meta$Onset <- as.factor(meta$Onset)

# Print tables for all relevant variables
tbls <- list()
for(c in c('Sample_type', 'MSI_status', candidate_covars)){
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

# save(list = c('meta', 'mat',
#               'tcga', 'query', 'tcga_meta', 'tcga_mat',
#               'yocrc_meta', 'yocrc_mat',
#               'design_formula', 'a', 'candidate_covars', 'filtering', 'alpha',
#               'tbls', 'valid_covars'),
#      file = 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Filtered_TCGA_YOCRC_data.RData')

load('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Filtered_TCGA_YOCRC_data.RData')

#'[ Check total number of reads

# meta$Reads <- colSums(mat)
# meta$Cohort_onset <- NA
# meta[meta$Cohort == 'TCGA' & meta$Onset == 'Early',]$Cohort_onset <- 'TCGA_early'
# meta[meta$Cohort == 'TCGA' & meta$Onset == 'Average',]$Cohort_onset <- 'TCGA_average'
# meta[meta$Cohort == 'YOCRC' & meta$Onset == 'Early',]$Cohort_onset <- 'YOCRC_early'
# #meta[meta$Cohort == 'YOCRC' & meta$Onset == 'Average',]$Cohort_onset <- 'YOCRC_average'
# 
# tcga_sums <- colSums(mat[,1:497])
# yocrc_sums <- colSums(mat[,498:559])
# 
# 
# # Create bar plot
# p1 <- ggplot(meta, aes(x = Reads, fill = Cohort_onset)) +
#   geom_histogram(alpha=0.5, position="identity")
# print(p1)

#'[ DESEQ2

dds <- DESeqDataSetFromMatrix(mat,
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
#'* Since age is continuous, we arbitrarily use 5 *
# round(dim(tcga_mat)[2] / 100)
if(filtering == 'Filtering.Pre.Ind'){
  keep <- rowSums(counts(dds) >= 10) >= 5
  dds <- dds[keep,]
}

# Run Deseq 
dds <- DESeq(dds)

#'[ PCA

vsd <- vst(dds, blind=FALSE)
DESeq2::plotPCA(vsd, intgroup = "Cohort") #+ geom_text(aes(label=name),vjust=2)
ggsave('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/DESeq2_PCA_Cohort.png',
       height=6, width=6, dpi=600)

#'* Method 2 - visualize transformed data with covariates adjusted *
mat <- assay(vsd)
mm <- model.matrix(~Age_scaled, colData(vsd))
covariates <- model.matrix(~Treatment + Side + Sex + Stage + Cohort, data=meta)[,-1]
mat <- limma::removeBatchEffect(mat, covariates = covariates, design=mm)
assay(vsd) <- mat
DESeq2::plotPCA(vsd, intgroup = "Cohort")
ggsave('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/DESeq2_adjusted_PCA_Cohort.png',
       height=6, width=6)




#'[ Get Results

print(resultsNames(dds))

# Get results
# Specify cutoff threshold for independent filtering
res <- results(dds, name=a, alpha=alpha)
#res <- results(dds, name='Onset_Early_vs_Average', alpha=alpha)


# Get mapping from gene ID to symbol from tcga biolinks object
mapping <- as.data.frame(rowData(tcga))
mapping <- mapping[,c('gene_id', 'gene_type', 'gene_name')]

# Map gene id to gene name with original mapping gotten from counts file
res$gene_id <- rownames(res)
res <- merge(as.data.frame(res), mapping, by='gene_id', all.x=T)

# Order results by padj value and reorder columns
res <- res[order(res$padj),][,c(1,8,9,2,3,4,5,6,7)]

# Keep only significant genes
res_sig <- res[(res$padj < alpha) & !is.na(res$padj),]

#'[ Save results 

info <- data.frame(Design = c(deparse(design_formula)))

de_results <- list("Metadata" = meta,
                   "Design" = info, "Variable_counts" = tbls,
                   "DE_results" = res, "DE_sig" = res_sig)
file_name <- paste0('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/DE_results/TCGA_YOCRC_MSS_',
                    a, '_DE_', paste(valid_covars, collapse = "."),
                    '.adjusted_', filtering, '.', alpha, '.xlsx')
write.xlsx(de_results, file = file_name)


#' #'[ Check overlap with genes in draft/paper
#' 
#' DEGs <- read.xlsx('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated.xlsx',
#'                   sheet='repeatDEGs')
#' 
#' res_overlap <- res[res$gene_name %in% DEGs$Gene,]
#' 
#' # Add if directionality matches
#' res_overlap$Direction_match <- TRUE
#' for(g in res_overlap$gene_name){
#'   # Get sign of bulk fold change
#'   bulk_sign <- sign(res_overlap[res_overlap$gene_name == g,]$log2FoldChange)
#'   # Positive = FALSE, Negative = TRUE
#'   if(bulk_sign == 1){bulk_sign <- F}
#'   if(bulk_sign == -1){bulk_sign <- T}
#'   
#'   # TRUE if sc fold change contains a minus (-)
#'   sc_sign <- DEGs[DEGs$Gene == g,]$FC
#'   sc_sign <- grepl('-', sc_sign, fixed=T)
#'   
#'   # If signs disagree, update df
#'   if(bulk_sign != sc_sign){
#'     res_overlap[res_overlap$gene_name == g,]$Direction_match <- FALSE
#'   }
#' }
#' 
#' res_sig_overlap <- res_overlap[res_overlap$padj < alpha,]
#' 
#' 
#' info <- data.frame(Design = c(deparse(design_formula)))
#' 
#' #'[ Save results as excel sheet
#' 
#' de_results <- list("Metadata" = meta,
#'                    "Design" = info, "Variable_counts" = tbls,
#'                    "DE_results" = res, "DE_sig" = res_sig,
#'                    "DE_results_overlap" = res_overlap,
#'                    "DE_sig_overlap" = res_sig_overlap)
#' file_name <- paste0('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/DE_results/TCGA_YOCRC_MSS_',
#'                     a, '_DE_', paste(valid_covars, collapse = "."),
#'                     '.adjusted_', filtering, '.', alpha, '.xlsx')
#' write.xlsx(de_results, file = file_name)


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


