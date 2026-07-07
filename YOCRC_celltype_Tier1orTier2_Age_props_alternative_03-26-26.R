rm(list = ls())

library(ggplot2)
library(data.table)
library(DirichletReg)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(pheatmap)


proj.path <- '/home/EOCRC/'
user.path <- '/home/cporter/'
date <- '03_26_2026_age_alternative_allCovs_unkStageUpdated'
save.path <- paste0(proj.path, '/proportions_', date, '/')
dir.create(save.path)

# source the dirichlet_regression function 
source(paste0(user.path, '/code/dirichlet_regression_9-20-24.R'))

# Tier 1
annot_tier <- 'Tier1'
data.path <- paste0(proj.path, 'Annotation_Tier1_counts_09-19-25.csv')
run_celltypes = c('Epithelial', 'Stromal', 'Myeloid', 'Endothelial', 'T', 'B', 'Glial/Neuronal')

width = 6
height = 8
ncol = 2


########################################################################################################
# load proportions
counts.orig <- read.table(data.path, fill=TRUE, sep=",", colClasses = "character", stringsAsFactors=FALSE)

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
covariates = covariates[covariates$msi == "MSS: STABLE", ]
counts = counts[rownames(counts) %in% rownames(covariates), ]
subset = 'MSS'

counts$counts = DR_data(counts)
data = cbind(counts, covariates)
b=1
fit = DirichReg(counts ~ age_scaled+side+therapy+sex+stage|age_scaled+side+therapy+sex+stage, data, model="alternative", base=b)
u = summary(fit)

# get pvalues
pvals = u$coef.mat[grep('Intercept', rownames(u$coef.mat), invert = TRUE), 4]
v = names(pvals)
pvals = matrix(pvals, ncol = length(u$varnames))
rownames(pvals) = gsub('condition', '', v[1:nrow(pvals)])
pvals = pvals[,-ncol(pvals)]
colnames(pvals) = u$varnames[-b]
fit$pvals = pvals
adjustedP <- matrix(p.adjust(pvals, method = "fdr"), nrow = nrow(pvals), ncol = ncol(pvals))
rownames(adjustedP) <- rownames(pvals)
colnames(adjustedP) <- colnames(pvals)

# Get coefficients
coefs <- as.data.frame(fit$coefficients)

# save to CSV
write.csv(adjustedP, paste0(save.path, annot_tier, '_LDA_adjusted_pvals-FDR_', date, '_', subset, '_', u$varnames[b], 'Base_altModel_all-cell-types.csv'))
write.csv(coefs, paste0(save.path, annot_tier, '_LDA_Coefs_', date, '_', subset, '_', u$varnames[b], 'Base_altModel_all-cell-types.csv'))


################# Look at MSI only ##################################################
print('Running MSI...')

# reset data 
counts = counts_all
covariates = covariates_all

# subset
rownames(covariates) = rownames(counts)
covariates = covariates[covariates$msi == "MSI-H: HIGH", ]
counts = counts[rownames(counts) %in% rownames(covariates), ]
subset = 'MSI'

counts$counts = DR_data(counts)
data = cbind(counts, covariates)
b=1
fit = DirichReg(counts ~ age+side|age+side, data, model="alternative", base=b)
u = summary(fit)

# get pvalues
pvals = u$coef.mat[grep('Intercept', rownames(u$coef.mat), invert = TRUE), 4]
v = names(pvals)
pvals = matrix(pvals, ncol = length(u$varnames))
rownames(pvals) = gsub('condition', '', v[1:nrow(pvals)])
pvals = pvals[,-ncol(pvals)]
colnames(pvals) = u$varnames[-b]
fit$pvals = pvals
adjustedP <- matrix(p.adjust(pvals, method = "fdr"), nrow = nrow(pvals), ncol = ncol(pvals))
rownames(adjustedP) <- rownames(pvals)
colnames(adjustedP) <- colnames(pvals)

# Get coefficients
coefs <- as.data.frame(fit$coefficients)

# save to CSV
write.csv(adjustedP, paste0(save.path, annot_tier, '_LDA_adjusted_pvals-FDR_', date, '_', subset, '_', u$varnames[b], 'Base_altModel_all-cell-types.csv'))
write.csv(coefs, paste0(save.path, annot_tier, '_LDA_Coefs_', date, '_', subset, '_', u$varnames[b], 'Base_altModel_all-cell-types.csv'))