# TRANSCRIPTOMICS QUIZ ANSWERS
# LATEST, UPDATED VERSION
# DISREGARD EARLIER SUBMISSIONS

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

# Load count matrix
countMatrix <- as.matrix(
  read.csv(
    here(
      "ServerData",
      "transcriptomics_lab",
      "06_Quiz",
      "transcriptomicsQuizData.txt"
    ),
    sep = "\t",
    row.names = "gene_id"
  )
)

# Define sample names
sampleNames