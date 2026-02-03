# TRANSCRIPTOMICS QUIZ ANSWERS
# LATEST UPDATED VERSION
# DISREGARD EARLIER SUBMISSIONS


# SETUP ####

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

# Clear variables
rm(list = ls())


# Load count matrix
countMatrix <- as.matrix(
  read.csv(
    here("transcriptomics", "Quiz", "data.txt"),
    sep = "\t",
    row.names = "gene_id"
  )
)

# Define sample names
sampleNames <- c(
  paste0("Pca_Ribes_rep", 1:9),
  paste0("Pca_Salix_rep", 1:9),
  paste0("Pca_Urtica_rep", 1:9)
)

# Define sample conditions
sampleConditions <- c(rep("Ribes", 9), rep("Salix", 9), rep("Urtica", 9))

# Create sample table from sample conditions
sampleTable <- data.frame(condition = as.factor(sampleConditions))
row.names(sampleTable) <- sampleNames

# Create dds object
dds <- DESeqDataSetFromMatrix(
  countData = countMatrix, colData = sampleTable, design = ~ condition
)

# Estimate size factors
dds <- estimateSizeFactors(dds)


# QUESTIONS 1-2 ####

# Transform data with regularized log transformation
rld <- rlog(dds, blind = TRUE)

# Generate PCA plot of the 1000 most variable genes
pdf(here("transcriptomics", "Quiz", "Todreas_pca.pdf"))
DESeq2::plotPCA(rld, intgroup = c("condition"), ntop = 1000)
dev.off()


# QUESTION 3 ####

# Run DESeq on dds object
dds <- DESeq(dds)

# Specify levels
contrast_pr <- c("condition", "Urtica", "Ribes")

# Extract results of the contrast Urtica vs. Ribes
res_table <- results(dds, contrast = contrast_pr)

# Sort results by adjusted p-value
res_table <- res_table[order(res_table$padj),]

# Get the most differentially expressed gene
rownames(res_table)[1]


# QUESTION 4 ####

# Get the fold change of the most DE gene in Ribes relative to Urtica
signif(2^(abs(res_table$log2FoldChange[1])), 3)


# QUESTION 5 ####

# Determine how many DE genes pass the significance and fold change filter
nrow(subset(res_table , padj < 0.01 & abs(log2FoldChange) > 1))