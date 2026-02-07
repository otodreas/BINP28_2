# 1: Aim, data, installation
## 1.1: Aim

The goal is to work with 16S rRNA gene amplicon sequencing data. We start with `fastq` files with DNA fragments.

## 1.2: Data
### 1.2.1: `fastq`

There are 118 `fastq` files in total, corresponding to 59 runs, one file for a forward read, one file for a reverse read.

*Note: a colony is composed of various castes, each with a unique function.*

# 2: Analysis
## 2.1: Quality control

`fastqc` highlights areas in libraries that look unusual so that you know where to take a closer look.

## 2.2 Sequence clipping and removal

Trimmomatic output example:
- mySampleFiltered_1P.fq.gz - for paired forward reads
- mySampleFiltered_1U.fq.gz - for unpaired forward reads
- mySampleFiltered_2P.fq.gz - for paired reverse reads
- mySampleFiltered_2U.fq.gz - for unpaired reverse reads