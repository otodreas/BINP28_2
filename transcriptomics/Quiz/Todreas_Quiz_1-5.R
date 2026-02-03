# TRANSCRIPTOMICS QUIZ ANSWERS
# LATEST, UPDATED VERSION
# DISREGARD EARLIER SUBMISSIONS

#################################### SETUP ####################################

# # Install packages
# if (!requireNamespace("BiocManager", quietly = TRUE)) {
#   install.packages("BiocManager")
# }

# BiocManager::install("DESeq2")
# install.packages("gplots")
# install.packages("pheatmap")
# install.packages("RColorBrewer")
# install.packages("tidyverse")
# install.packages("here")

# # Mount packages
# library(DESeq2)
# library(gplots)
# library(pheatmap)
# library(RColorBrewer)
# library(tidyverse)
# library(here)

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

################################## QUESTION 1 #################################

# Estimate size factors
dds <- estimateSizeFactors(dds)

# Instantiate dataframe with normalized counts
normalized_counts <- as.data.frame(counts(dds, normalized = TRUE))

# Transform data with regularized log transformation
rld <- rlog(dds, blind = TRUE)

# PCA
pdf(here("transcriptomics", "Quiz", "Todreas_pca.pdf"))
DESeq2::plotPCA(rld, intgroup = c("condition"), ntop = 500)
dev.off()