# This script runs Dirichlet regression using the full model (no reference cell type)
rm(list = ls())

library(ggplot2)
library(data.table)
library(DirichletReg)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(pheatmap)

proj.path <- '/home/EOCRC/results/'
user.path <- '/home/cporter/'
date <- '05_18_2026_ageScaled_sideTherapySexStage_updatedUnkStage_ageFDR'
save.path <- paste0(proj.path, '/proportions_', date, '/')
dir.create(save.path)

# source the dirichlet_regression function 
source(paste0(user.path, '/code/dirichlet_regression_9-20-24.R'))

# Uncomment from the below options depending on what you are testing 
# Tier 1
annot_tier <- 'Tier1'
data.path <- paste0(proj.path, 'Annotation_Tier1_counts_09-19-25.csv')
run_celltypes = c('Epithelial', 'Stromal', 'Myeloid', 'Endothelial', 'T', 'B', 'Glial/Neuronal')

# # Tier 2
# annot_tier <- 'Tier2'
# data.path <- paste0(proj.path, 'Annotation_Tier2_counts_09-19-25.csv')
# run_celltypes = c('Adipocytes', 'B cell', 'CD4 T cells', 'CD8 T cells',
#                   'CEACAM1 colonocyte-like', 'Cycing endothelium', 'Cycling Myeloid',
#                   'Cycling Stromal', 'Cycling T cells', 'Cycling plasma cell', 'DC',
#                   'Enteroendocrine-like', 'Fibroblast', 'Fibroblast-BMP5-SOX6',
#                   'Fibroblast-C3', 'Fibroblast-Infl', 'Fibroblast-KCNN3',
#                   'Fibroblast-MMP2-THY1', 'Germinal center / Cycling B cell',
#                   'Glial cells', 'HSP-hi - B cell', 'HSP-hi Myeloid',
#                   'HSP-hi Stromal', 'HSP-hi T cells', 'HSP-hi glial', 'ILCs',
#                   'LGR5 stem cell-like', 'Lymphatic endothelium',
#                   'MT-Ribo-hi Myeloid', 'MT-Ribo-hi Stromal', 'MT-Ribo-hi T cells',
#                   'MT-Ribo-hi endothelium', 'MT-Ribo-hi epithelial',
#                   'MUC2 goblet-like', 'Macrophage-Monocyte', 'Mast',
#                   'Myofibroblast-SMC', 'NK-Cytotoxic T cells', 'Neuronal cells',
#                   'Neutrophil', 'Patient-specific', 'Pericytes', 'Plasma cell',
#                   'Regulatory T cells', 'T helper cells', 'Vascular endothelium')

# # Tier 2 - EPI ONLY
# annot_tier <- 'Tier2_epi'
# data.path <- paste0(proj.path, 'Annotation_Tier2_counts_09-19-25.csv')
# run_celltypes = c('LGR5 stem cell-like', 'CEACAM1 colonocyte-like',
#                   'MT-Ribo-hi epithelial','MUC2 goblet-like', 'Enteroendocrine-like', 'Patient-specific')


########################################################################################################
# functions 
calculate_regression_sideTherapySexStageCov <- function(counts, covariates, save.path, date, annot_tier, subset) {
  # Calculate regression
  counts$counts = DR_data(counts)
  data = cbind(counts, covariates)
  fit = DirichReg(counts ~ age_scaled+side+therapy+sex+stage, data)
  
  # Get p-values
  u = summary(fit)
  pvals = u$coef.mat[grep('Intercept', rownames(u$coef.mat), invert = TRUE), 4]
  v = names(pvals)
  pvals = matrix(pvals, ncol = length(u$varnames))
  rownames(pvals) = gsub('condition', '', v[1:nrow(pvals)])
  colnames(pvals) = u$varnames
  fit$pvals = pvals
  
  # Get adjusted p-values
  adjustedP <- matrix(p.adjust(pvals, method = "fdr"), nrow = nrow(pvals), ncol = ncol(pvals))
  rownames(adjustedP) <- rownames(pvals)
  colnames(adjustedP) <- colnames(pvals)

  age_row_idx <- grep("age_scaled", rownames(pvals))
  age_pvals <- pvals[age_row_idx, , drop = FALSE]
  age_adjustedP <- matrix(p.adjust(age_pvals, method = "fdr"), 
                          nrow = nrow(age_pvals), 
                          ncol = ncol(age_pvals))
  rownames(age_adjustedP) <- rownames(age_pvals)
  colnames(age_adjustedP) <- colnames(age_pvals)
  
  # Get coefficients
  coefs <- as.data.frame(fit$coefficients)
  
  # save to CSV
  write.csv(age_adjustedP, paste0(save.path, annot_tier, '_LDA_AGE_adjusted_pvals-FDR_', date, '_', subset, '_all-cell-types.csv'))
  write.csv(adjustedP, paste0(save.path, annot_tier, '_LDA_adjusted_pvals-FDR_', date, '_', subset, '_all-cell-types.csv'))
  write.csv(coefs, paste0(save.path, annot_tier, '_LDA_Coefs_', date, '_', subset, '_all-cell-types.csv'))
  
  return(list(adjustedP = adjustedP, coefs = coefs))
}

calculate_regression_sideSexStageCov <- function(counts, covariates, save.path, date, annot_tier, subset) {
  # Calculate regression
  counts$counts = DR_data(counts)
  data = cbind(counts, covariates)
  fit = DirichReg(counts ~ age_scaled+side+sex+stage, data)
  
  # Get p-values
  u = summary(fit)
  pvals = u$coef.mat[grep('Intercept', rownames(u$coef.mat), invert = TRUE), 4]
  v = names(pvals)
  pvals = matrix(pvals, ncol = length(u$varnames))
  rownames(pvals) = gsub('condition', '', v[1:nrow(pvals)])
  colnames(pvals) = u$varnames
  fit$pvals = pvals
  
  # Get adjusted p-values
  adjustedP <- matrix(p.adjust(pvals, method = "fdr"), nrow = nrow(pvals), ncol = ncol(pvals))
  rownames(adjustedP) <- rownames(pvals)
  colnames(adjustedP) <- colnames(pvals)
  
  age_row_idx <- grep("age_scaled", rownames(pvals))
  age_pvals <- pvals[age_row_idx, , drop = FALSE]
  age_adjustedP <- matrix(p.adjust(age_pvals, method = "fdr"), 
                          nrow = nrow(age_pvals), 
                          ncol = ncol(age_pvals))
  rownames(age_adjustedP) <- rownames(age_pvals)
  colnames(age_adjustedP) <- colnames(age_pvals)
  
  # Get coefficients
  coefs <- as.data.frame(fit$coefficients)
  
  # save to CSV
  write.csv(age_adjustedP, paste0(save.path, annot_tier, '_LDA_AGE_adjusted_pvals-FDR_', date, '_', subset, '_all-cell-types.csv'))
  write.csv(adjustedP, paste0(save.path, annot_tier, '_LDA_adjusted_pvals-FDR_', date, '_', subset, '_all-cell-types.csv'))
  write.csv(coefs, paste0(save.path, annot_tier, '_LDA_Coefs_', date, '_', subset, '_all-cell-types.csv'))
  
  return(list(adjustedP = adjustedP, coefs = coefs))
}


########################################################################################################
# load proportions
counts.orig <- read.table(data.path, fill=TRUE, sep=",", colClasses  = "character", stringsAsFactors=FALSE)

# format counts matrix 
counts <- as.matrix(t(counts.orig[2:nrow(counts.orig), 2:ncol(counts.orig)]))
tmp <- as.vector(t(counts.orig[1,2:ncol(counts.orig)]))
rownames(counts) <- tmp
tmp <- as.vector(t(counts.orig[2:nrow(counts.orig),1]))
colnames(counts) <- tmp
rm(counts.orig)

# keep only cell types to test 
counts = counts[,run_celltypes]

# convert strings to #s
counts.num <- matrix(nrow=nrow(counts), ncol=ncol(counts))
for (i in 1:nrow(counts)){
  for (j in 1:ncol(counts)) {
    counts.num[i,j] <- as.numeric(counts[i,j])
  }
}

# set row and column names, remove counts 
rownames(counts.num) <- rownames(counts)
colnames(counts.num) <- colnames(counts)
rm(counts)

# Load in covariate information 
cohort <- read.table(paste0(proj.path, 'simple_metadata.csv'), fill=TRUE, sep=",", colClasses = "character", stringsAsFactors=FALSE, quote = "\"")
colnames(cohort)=cohort[1,]
cohort = cohort[-1,]

# create covariate matrix
# initialize data frame 
covariates <- data.frame(
  condition = rownames(counts.num),
  side = rownames(counts.num),
  msi = rownames(counts.num),
  therapy = rownames(counts.num),
  decade = rownames(counts.num),
  age = rownames(counts.num), 
  stage = rownames(counts.num), 
  sex = rownames(counts.num)

)

# fill data frame 
covariates$condition <- factor(cohort$Cohort[match(covariates$condition, cohort$FRID)])
covariates$side <- factor(cohort$Sidedness[match(covariates$side, cohort$FRID)])
covariates$msi <- factor(cohort$MSI_v2[match(covariates$msi, cohort$FRID)])
covariates$therapy <- factor(cohort$Therapy_v2[match(covariates$therapy, cohort$FRID)])
covariates$decade <- factor(cohort$Decade[match(covariates$decade, cohort$FRID)])
covariates$age <- as.numeric(cohort$Age[match(covariates$age, cohort$FRID)])
covariates$stage <- factor(cohort$Overall_Stage[match(covariates$stage, cohort$FRID)])
covariates$sex <- factor(cohort$Sex[match(covariates$sex, cohort$FRID)])

covariates$age_scaled <- as.numeric(scale(covariates$age))

# reassign variable to match code below 
counts=counts.num
rm(counts.num)

# calculate and store the percentage for each sample
counts.pct = 100*counts/rowSums(counts)

# Fix counts matrix if generated with table
counts = as.data.frame.matrix(counts)

# Store counts data 
counts_all = counts
covariates_all = covariates 


################# Look at MSS only ##################################################
print ('Running MSS...')

# reset data 
counts = counts_all
covariates = covariates_all

# subset
rownames(covariates) = rownames(counts)
covariates = covariates[(covariates$msi == "MSS: STABLE"), ]
counts = counts[rownames(counts) %in% rownames(covariates), ]
subset = 'MSS'

# calculate regression 
dr_result = calculate_regression_sideTherapySexStageCov(counts, covariates, save.path, date, annot_tier, subset)

# Make an age by cell type df and plot
tmp = counts.pct[rownames(covariates),]
df_all = merge(tmp, covariates, by = "row.names", all = TRUE)
rownames(df_all) = df_all$Row.names

df = df_all[, !(colnames(df_all) %in% c('condition', 'side', 'msi', 'therapy', 'sex', 'stage', 'age_scaled'))]
df$Row.names = NULL
df$Sample = rownames(df)
df_long <- df %>%
  pivot_longer(cols = run_celltypes, 
               names_to = "CellType", 
               values_to = "Percentage")

# reorder the results so the cell types are grouped by Tier 1 cell type 
df_long$CellType = factor(df_long$CellType, levels = run_celltypes)

if (annot_tier == "Tier2_epi"){
  w=10
} else {w=20}
# plot only significant if tier2 
if (annot_tier == "Tier2"){
  #df_long = df_long[df_long$CellType %in% names(which(dr_result$adjustedP['age_scaled',]<0.05)),]  
  df_long = df_long[df_long$CellType %in% c('LGR5 stem cell-like', 'CEACAM1 colonocyte-like', 'MT-Ribo-hi epithelial', 'MUC2 goblet-like', 'Enteroendocrine-like'),]
  df_long$CellType = factor(df_long$CellType, levels=c('LGR5 stem cell-like', 'CEACAM1 colonocyte-like', 'MT-Ribo-hi epithelial', 'MUC2 goblet-like', 'Enteroendocrine-like'))
  w=10
} else {w=20}


# Look at a line plot of age 
p = ggplot(df_long, aes(x = age, y = Percentage)) +
  geom_point(alpha = 0.3) +  # keep points, but transparent
  geom_smooth(method = "loess", se = TRUE, color = "red", size = 1) +  # smooth trend + CI
  facet_wrap(~ CellType, scales = "free_y", nrow=1) +
  xlab("Age") +
  ylab("Cell Type Percentage") +
  theme_minimal() + 
  theme(plot.margin = ggplot2::margin(t = 5, r = 20, b = 5, l = 5)) # Fixed with explicit namespace!
p
ggsave(paste0(save.path, annot_tier, "_smoothed_by_age_", date, "_allCellTypes_", subset, ".pdf"), plot = p, width = w, height = 3, units = "in")

################# Look at MSI only ##################################################
print ('Running MSI...')

# reset data 
counts = counts_all
covariates = covariates_all

# subset
rownames(covariates) = rownames(counts)
covariates = covariates[(covariates$msi == "MSI-H: HIGH"), ]
counts = counts[rownames(counts) %in% rownames(covariates), ]
subset = 'MSI'

# remove Not Applicable Stage --> ADD TO METHODS
idx = grep("Not Applicable", covariates$stage)
counts = counts[-idx, ]
covariates = covariates[-idx, ]
covariates$stage[covariates$stage == "IV"] = "III" 
covariates$stage = droplevels(covariates$stage)
covariates$side = droplevels(covariates$side)

# calculate regression 
dr_result = calculate_regression_sideSexStageCov(counts, covariates, save.path, date, annot_tier, subset)

# Make an age by cell type df and plot
tmp = counts.pct[rownames(covariates),]
df_all = merge(tmp, covariates, by = "row.names", all = TRUE)
rownames(df_all) = df_all$Row.names

df = df_all[, !(colnames(df_all) %in% c('condition', 'side', 'msi', 'therapy', 'sex', 'stage', 'age_scaled'))]
df$Row.names = NULL
df$Sample = rownames(df)
df_long <- df %>%
  pivot_longer(cols = run_celltypes, 
               names_to = "CellType", 
               values_to = "Percentage")

# reorder the results so the cell types are grouped by Tier 1 cell type 
df_long$CellType = factor(df_long$CellType, levels = run_celltypes)

# plot only significant if tier2 
if (annot_tier == "Tier2"){
  df_long = df_long[df_long$CellType %in% names(which(dr_result$adjustedP['age_scaled',]<0.05)),]  
  w=10
} else {w=20}

# Look at a line plot of age 
p = ggplot(df_long, aes(x = age, y = Percentage)) +
  geom_point(alpha = 0.3) +  # keep points, but transparent
  geom_smooth(method = "loess", se = TRUE, color = "red", size = 1) +  # smooth trend + CI
  facet_wrap(~ CellType, scales = "free_y", nrow=1) +
  xlab("Age") +
  ylab("Cell Type Percentage") +
  theme_minimal() + 
  theme(plot.margin = ggplot2::margin(t = 5, r = 20, b = 5, l = 5)) # Fixed with explicit namespace!
p
ggsave(paste0(save.path, annot_tier, "_smoothed_by_age_", date, "_allCellTypes_", subset, ".pdf"), plot = p, width = w, height = 3, units = "in")

