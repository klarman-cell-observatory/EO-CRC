library(dplyr)
library(ggplot2)
library(ggrepel)
library(tidyverse)
library(openxlsx)


#'[ Import DE results

# Get bulk results
res <- read.xlsx('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/DE_results/TCGA_YOCRC_MSS_Age_scaled_DE_Treatment.Side.Sex.Stage.Cohort.adjusted_Filtering.Pre.Ind.0.1.xlsx',
                 sheet = 'DE_results')
# res <- read.xlsx('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/DE_results/TCGA_YOCRC_MSS_Age_scaled_DE_Treatment.Side.Sex.Stage.Cohort.adjusted_Filtering.Pre.Ind.0.1.xlsx',
#                  sheet = 'DE_sig')

lfc_up <- 1
lfc_down <- -1
p <- 0.1

#' #'[ Barplot for lncRNAs
#' 
#' sig <- res[(res$padj < 0.1) & !is.na(res$padj),]
#' 
#' pos_lncRNA <- sig[(sig$log2FoldChange > 0) & (sig$gene_type == 'lncRNA'),]
#' pos_other <- sig[(sig$log2FoldChange > 0) & (sig$gene_type != 'lncRNA'),]
#' neg_lncRNA <- sig[(sig$log2FoldChange < 0) & (sig$gene_type == 'lncRNA'),]
#' neg_other <- sig[(sig$log2FoldChange < 0) & (sig$gene_type != 'lncRNA'),]
#' 
#' data <- data.frame(DEG_proportion = c(nrow(pos_lncRNA),
#'                                       nrow(pos_other),
#'                                       nrow(neg_lncRNA),
#'                                       nrow(neg_other)),
#'                    Direction = c('High in AO', 'High in AO', 'High in EO', 'High in EO'),
#'                    Gene_type = c('lncRNA', 'non-lncRNA', 'lncRNA', 'non-lncRNA'))
#' data$Direction <- factor(data$Direction, levels=c('High in EO', 'High in AO'))
#' 
#' p0 <- ggplot(data, aes(y=DEG_proportion, x=Direction, fill=Gene_type)) + 
#'   geom_bar(position="fill", stat="identity") +
#'   scale_fill_manual(values=c('lncRNA'="grey70", 'non-lncRNA'="grey40"),
#'                      breaks = c('lncRNA', 'non-lncRNA')) +
#'   labs(x=NULL, fill=NULL) +
#'   theme_minimal() +
#'   theme(plot.background = element_rect(fill = "transparent", colour = NA),
#'         panel.background = element_rect(fill = "transparent", colour = NA))
#' 
#' print(p0)
#'
# # Save plot
# fname <- 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/lncRNA_proportion_sig_DEGs.pdf'
# #png(fname, units="in", width=4, height=3, res=600, bg = 'transparent')
# pdf(fname, width=4, height=3, bg = 'transparent')
# print(p0)
# dev.off()

#' #'[ Volcano plot for DE results - ALL
#' 
#' # Remove genes with NAs at any point (NA in padj value means it's been filtered out)
#' data <- na.omit(res)
#' 
#' # add a column of NAs
#' data$Significant <- "NO"
#' # if log2Foldchange > 1 and padj < 0.05, set as "UP" 
#' data$Significant[(data$log2FoldChange > lfc_up) & (data$padj < p)] <- "UP"
#' # if log2Foldchange < -1 and padj < 0.05, set as "DOWN"
#' data$Significant[(data$log2FoldChange < lfc_down) & (data$padj < p)] <- "DOWN"
#' 
#' # Create labels for significant gene sets
#' data$label <- NA
#' data$label[(data$log2FoldChange > lfc_up | 
#'               data$log2FoldChange < lfc_down) & 
#'              (data$padj < p) & 
#'              !is.na(data$padj)] <- data$gene_name[(data$log2FoldChange > lfc_up | 
#'                                                      data$log2FoldChange < lfc_down) &
#'                                                     (data$padj < p) & !is.na(data$padj)]
#' 
#' 
#' # Plot volcano plot
#' p1 <- ggplot(data=data, aes(x=log2FoldChange, y=-log10(padj),
#'                            col=Significant, label=label,
#'                            alpha=Significant)) + 
#'   geom_point() + theme_minimal() +
#'   # Add intercept lines 
#'   geom_hline(yintercept=-log10(p), linetype = "dashed", color = 'red', alpha=0.3) +
#'   geom_vline(xintercept = lfc_up, linetype = "dashed", color = 'red', alpha=0.3) +
#'   geom_vline(xintercept = lfc_down, linetype = "dashed", color = 'red', alpha=0.3) +
#'   # Add point labels (legend = FALSE to remove 'a' superimposed on legend points)
#'   geom_text_repel(size = 3, show.legend = FALSE) +
#'   # Set color and opacity based on significance status
#'   scale_color_manual(values=c('NO'="black", 'DOWN'="blue", 'UP'="red"),
#'                      breaks = c('NO', 'DOWN', 'UP')) +
#'   scale_alpha_manual(values = c('NO'=0.1, 'DOWN'=1, 'UP'=1), guide='none')
#'   # geom_text(aes(2.5, -log10(p), label = paste0('padj = ', p), vjust = -1),
#'   #           show.legend = FALSE)
#' 
#' 
#' # Save plot
#' fname <- 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/Volcano_all_DEGs.png'
#' png(fname, units="in", width=12, height=8, res=600)
#' print(p1)
#' dev.off()


#'[ Get all SC DEGs

sheets <- getSheetNames('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated.xlsx')
#sheets <- sheets[1]

all <- data.frame()

for(s in sheets){
  print(s)
  
  # Get SC results
  DEGs <- read.xlsx('C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous/pseudobulk_DEG_results_MSSonly_sideTherapySexStageCov_1pctExpressed_contScaleAge_03-02-2026_unkStageUpdated.xlsx',
                    sheet=s)
  genes <- data.frame(Gene = DEGs$Gene)
  
  cat('All DEGs:', dim(genes)[1], '\n')
  
  # Get FC sign of each DEG
  if(s == 'repeatDEGs'){
    genes <- DEGs[,c('Gene', 'FC')]
    colnames(genes) <- c('gene_name', 'SC_sign')
    # Get FC sign
    genes$SC_sign <-  ifelse(grepl('-', genes$SC_sign, fixed=T),
                        -1, 1)
  } else {
    genes <- DEGs[,c('Gene', 'log2FoldChange')]
    colnames(genes) <- c('gene_name', 'SC_sign')
    genes$SC_sign <- sign(genes$SC_sign)
  }
  
  all <- rbind(all, genes)
}

# Check duplicated genes
dups <- all[duplicated(all$gene_name),]
# All duplicated genes have same direction (-1 or 1 count is zero)
table(dups$gene_name, dups$SC) 
# Remove duplicates
all <- all[!duplicated(all$gene_name),]

#'[ Volcano plot for DE results - Overlap with SC DEGs

# Remove genes with NAs at any point (NA in padj value means it's been filtered out)
data <- na.omit(res)

# Add bulk and sc FC direction to data df
data$Bulk_sign <- sign(data$log2FoldChange)
data <- merge(data, all, by = 'gene_name', all.x = T)

# add a column of NAs
data$Significant <- "NO"
# # If gene in SC DEGs and significant in Bulk 
# data$Significant[(data$padj < p) & (data$gene_name %in% all$gene_name) &
#                    (data$log2FoldChange > 0)] <- 'UP'
# data$Significant[(data$padj < p) & (data$gene_name %in% all$gene_name) &
#                    (data$log2FoldChange < 0)] <- 'DOWN'

# If gene in SC DEGs and significant in Bulk AND same direction in Bulk/SC
data$Significant[(data$padj < p) & (data$gene_name %in% all$gene_name) &
                   (data$log2FoldChange > 0) &
                   (data$Bulk_sign == data$SC_sign)] <- 'UP'
data$Significant[(data$padj < p) & (data$gene_name %in% all$gene_name) &
                   (data$log2FoldChange < 0) &
                   (data$Bulk_sign == data$SC_sign)] <- 'DOWN'

# Create labels for significant genes
data$label <- NA
data$label[data$Significant == 'UP'] <- data$gene_name[data$Significant == 'UP']
data$label[data$Significant == 'DOWN'] <- data$gene_name[data$Significant == 'DOWN']



# Plot volcano plot
p2 <- ggplot(data=data, aes(x=log2FoldChange, y=-log10(padj),
                            color=Significant, label=label,
                            alpha=Significant)) + 
  geom_point(size = 1) + theme_minimal(base_size = 18) +
  # Add intercept line and annotation for padj cutoff
  geom_hline(yintercept=-log10(p), linetype = "dashed", color = 'red', alpha=0.3) +
  annotate(geom = 'text', x = 2.4, y = -log10(p) + 0.5, label = paste0('padj = ', p), size = 5) +

  # Add point labels (legend = FALSE to remove 'a' superimposed on legend points)
  geom_text_repel(aes(fontface = ifelse(Bulk_sign == SC_sign, "plain", "plain")),
                  size = 3, show.legend = FALSE, min.segment.length = 0,
                  max.overlaps = 10) + # Change max overlap to 15 for zoom
  # Set color and opacity based on significance status
  scale_color_manual(values=c('NO'="black", 'DOWN'="blue", 'UP'="red"),
                     breaks = c('NO', 'DOWN', 'UP')) +
  #coord_cartesian(xlim = c(-1, 2), ylim = c(0, 5)) +
  # normal alpha = 0.04, zoom alpha = 0.02
  scale_alpha_manual(values = c('NO'=0.04, 'DOWN'=1, 'UP'=1), guide='none')

print(p2)

# Save plot
# fname <- 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/Volcano_overlap_DEGs_same_direction.pdf'
# pdf(fname, width=12, height=8)
fname <- 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/Volcano_overlap_DEGs_same_direction.png'
png(fname, units="in", width=12, height=8, res=600)
print(p2)
dev.off()

# Plot volcano plot zoomed in
p3 <- ggplot(data=data, aes(x=log2FoldChange, y=-log10(padj),
                            color=Significant, label=label,
                            alpha=Significant)) + 
  geom_point(size = 1) + theme_minimal(base_size = 18) +
  # Add intercept line and annotation for padj cutoff
  geom_hline(yintercept=-log10(p), linetype = "dashed", color = 'red', alpha=0.3) +
  annotate(geom = 'text', x = 2, y = -log10(p) + 0.1, label = paste0('padj = ', p), size = 5) +
  # Add point labels (legend = FALSE to remove 'a' superimposed on legend points)
  geom_text_repel(aes(fontface = ifelse(Bulk_sign == SC_sign, "plain", "plain")),
                  size = 3, show.legend = FALSE, min.segment.length = 0,
                  max.overlaps = 15) + # Change max overlap to 15 for zoom
  # Set color and opacity based on significance status
  scale_color_manual(values=c('NO'="black", 'DOWN'="blue", 'UP'="red"),
                     breaks = c('NO', 'DOWN', 'UP')) +
  coord_cartesian(xlim = c(-1, 2), ylim = c(0, 5)) +
  # normal alpha = 0.04, zoom alpha = 0.02
  scale_alpha_manual(values = c('NO'=0.02, 'DOWN'=1, 'UP'=1), guide='none')

#print(p2)

# Save plot
# fname <- 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/Volcano_overlap_DEGs_same_direction_zoom.pdf'
# pdf(fname, width=12, height=8)
fname <- 'C:/Users/jcazaubiel/Documents/TCGA_COAD_READ/DE_age_continuous_YOCRC/Plots/Volcano_overlap_DEGs_same_direction_zoom.png'
png(fname, units="in", width=12, height=8, res=600)
print(p3)
dev.off()


