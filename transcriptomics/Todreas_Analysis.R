# TRANSCRIPTOMICS QUIZ SUBMISSION
# ANSWERS TO QUESTIONS ARE OUTLINED WITH A ROW OF COMMENT MARKS
# OLIVER E. TODREAS


# Install packages
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("DESeq2")
install.packages("gplots")
install.packages("pheatmap")
install.packages("RColorBrewer")
install.packages("tidyverse")
install.packages("here")

# Mount packages
library(DESeq2)
library(gplots)
library(pheatmap)
library(RColorBrewer)
library(tidyverse)
library(here)

# Load data (update path to data based on your working directory setup)
count_mat <- as.matrix(
  read.csv(
    here("transcriptomics", "final.matrix.txt"), sep = "\t", row.names = "gene_id"
  )
)

# Specify file names and experimental conditions
sampleNames <- dimnames(count_mat)[[2]]
sampleConditions <- c(rep("rich", 3), rep("poor", 3))

# Create a metadata table
sampleTable <- data.frame(condition = as.factor(sampleConditions))
row.names(sampleTable) <- sampleNames

# Instantiate DESeq object
dds <- DESeqDataSetFromMatrix(
  countData = count_mat, colData = sampleTable, design = ~ condition
)

# Estimate size factors
dds <- estimateSizeFactors(dds)

# Instantiate dataframe with normalized counts
normalized_counts <- as.data.frame(counts(dds, normalized = TRUE))

# Transform data with regularized log transformation
rld <- rlog(dds, blind = TRUE)


# QUESTION 1-2 ################################################################
# PCA (update path for pdf output based on your working directory setup)
pdf(here("transcriptomics", "Todreas_pca.pdf"))
DESeq2::plotPCA(rld, intgroup = c("condition"), ntop = 500)
dev.off()
###############################################################################

# Hierarchical clustering
distsRL <- dist(t(assay(rld)))
mat <- as.matrix(distsRL)
dimnames(mat) <- rep(
  list(with(colData(dds), paste(condition, sampleNames, sep = " : "))), 2
)
hc <- hclust(distsRL)

# Vizualize distances between samples
# (update path for pdf output based on your working directory setup)
hmcol <- colorRampPalette(brewer.pal(9, "GnBu"))(100)

pdf(here("transcriptomics", "Todreas_heatmap.pdf"))
heatmap.2(
  mat,
  Rowv = as.dendrogram(hc),
  symm = TRUE,
  trace = "none",
  col = rev(hmcol),
  margin = c(13, 13)
)
dev.off()


# QUESTION 3 ##################################################################
# Run DESeq on dds
dds <- DESeq(dds)
DESeq2::resultsNames(dds)
contrast_pr <- c("condition", "poor", "rich")
res_table <- results(dds, contrast = contrast_pr)
res_table <- res_table[order(res_table$padj),]
# Identify most differentially expressed gene
res_table$padj[1]
###############################################################################


# QUESTION 4 ##################################################################
# Create a plot and eyeball the answer
# Given the choices, expression seems to be about 7.89 times lower in Ribes
# relative to Utrica
plotCounts(
  dds, gene="fgenesh1_kg.12__183__Locus432v1rpkm387.16", intgroup = "condition"
)
###############################################################################


# QUESTION 5 ##################################################################
# Filter data and count rows
resSig <- subset(res_table, padj < 0.01 & abs(log2FoldChange) > 1)
nrow(resSig)
###############################################################################
