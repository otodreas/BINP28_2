#!/bin/bash


# Question 1
# ==========

echo 'Q1: NON-STANDARD NUCLEOTIDES'

# get non-header lines and count lines with non-standard nucleotides
grep -v '^>' ./prodigal_outputs/geoProteins.faa | grep -ci '[^GCTA]'

echo 'There are non-standard nucleotides in the genes'


# Question 2
# ==========

echo '\nQ2: START CODON FREQUENCY TABLE'

# get header lines
grep '^>' ./prodigal_outputs/geoProteins.faa | \
# get start codon field and extract the codon right of the equals sign
awk -F';' '{print $3}' | awk -F'=' '{print $2}' | \
# sort and count unique start codons
sort | uniq -c



# Question 3
# ==========

echo '\nQ3: # OF PREDICTED GENES VS # OF GENES IN REFERENCE GENOME'

# ECHO NUMBER OF PREDICTED GENES
# get number of genes
grep -c '^>' ./prodigal_outputs/geoGenes.fna | \
# print to terminal
awk '{print $1, "genes in prediction"}'


# ECHO NUMBER OF GENES IN REFERENCE GENOME
# sourced from https://www.ncbi.nlm.nih.gov/Traces/wgs/AYSF01
echo '3767 genes in reference genome'

echo '# of genes is similar between prediction and reference'

# Question 4
# ==========

echo '\nQ4: # OF GENES ON FORWARD AND REVERSE STRANDS'

# assign frequency table of genes by strand to a variable
genes_by_strand=$(
    # get genes
    grep '^>' ./prodigal_outputs/geoProteins.faa | \
    # isolate field identifying read direction
    awk -F'#' '{print $4}' | sort | uniq -c
)

# echo frequency of genes by read direction
echo $genes_by_strand | awk '{print $3, "genes in forward strand"}'
echo $genes_by_strand | awk '{print $1, "genes in reverse strand"}'


# Question 5
# ==========

# define gc calculator function (this function takes a few seconds to run)
calculate_gc() {
    # extract sequences, count nucleotide frequency, assign to function vars
    gc=$(grep -v '^>' $1 | grep -io '[GC]' | wc -l)
    ta=$(grep -v '^>' $1 | grep -io '[TA]' | wc -l)
    # echo % gc
    echo "$gc / ($gc + $ta) * 100" | bc -l
}

echo '\nQ5: GC CONTENT IN ASSEMBLY VS GENES'

# calculate and print % gc of assembly
calculate_gc ./prodigal_input/Assembly.fasta | \
awk '{print $1 "% GC in assembly"}'
# calculate and print % gc of genes
calculate_gc ./prodigal_outputs/geoProteins.faa | \
awk '{print $1 "% GC in genes"}'

echo 'GC content is higher in genes than in the full assembly'