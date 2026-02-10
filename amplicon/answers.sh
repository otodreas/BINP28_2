#! /bin/bash

# Questions 7 & 8
# Loop through colonies fastq files and check number of reads and average read length
SEQS_TOT=0
BASES_TOT=0
for file in Colonies/*.fastq; do
    SEQS=$(grep -c '^@' "$file")
    BASES=$(
        grep -A 1 --no-group-separator '^@' "$file" | \
        grep -v '^@' | \
        tr -d '\n' | \
        wc -c
    )
    ((SEQS_TOT += SEQS))
    ((BASES_TOT += BASES))
done
echo $SEQS_TOT
echo "scale=3; $BASES_TOT / $SEQS_TOT" | bc

# Run FastQC on all `fastq` files
for file in Colonies/*.fastq; do
    fastqc "$file" -o 1_fastqc/
done

# Run trimmomatic on all `fastq` files
ls Colonies/*_1.fastq | \
sed s/_1.fastq// | \
while read line; do 
    id=$(echo $line | sed "s/.*\///")
    java -jar ~/Tools/installs/Trimmomatic-0.40/trimmomatic-0.40.jar PE \
    -threads 8 \
    -trimlog 2_trimming/$id.log \
    -baseout 2_trimming/$id.fastq \
    ${line}_1.fastq \
    ${line}_2.fastq \
    LEADING:20 TRAILING:20 SLIDINGWINDOW:8:15 MINLEN:140 AVGQUAL:20
done > 2_trimming/trimmomatic_all.log 2>&1

# Question 14
# Get a rough idea of how many sequences were dropped during trimming
grep 'Dropped: ' 2_trimming/trimmomatic_all.log | \
awk -F'Dropped: ' '{ print $2 }'

# Question 15
# Run FastQC on all `fastq` files
for file in 2_trimming/*.fastq; do
    fastqc "$file" -o 2_trimming/fastqc_trimmed/
done

# Open fastqc reports (use zsh locally)
open \
1_fastqc/CT_A_1_fastqc.html \
2_trimming/fastqc_trimmed/CT_A_1P_fastqc.html \
1_fastqc/CT_C_2_fastqc.html \
2_trimming/fastqc_trimmed/CT_C_2P_fastqc.html \
1_fastqc/MA_A_2_fastqc.html \
2_trimming/fastqc_trimmed/MA_A_2U_fastqc.html

# Run pandaseq
for file in 2_trimming/*P.fastq; do
    id=$(echo "$file" | cut -d'/' -f2 | cut -d'_' -f1-2)
    pandaseq \
    -f 2_trimming/${id}_1P.fastq \
    -r 2_trimming/${id}_2P.fastq \
    -g 3_mergereads/${id}.log \
    -u 3_mergereads/${id}.unaligned.fasta \
    -w 3_mergereads/${id}.fastq \
    -F
done

# Question 17
# Compute average length of merged sequences
SEQS_TOT=0
BASES=0
for file in 3_mergereads/*.fastq; do
    SEQS=$(grep -c '^@' "$file")
    BASES=$(
        grep -A 1 --no-group-separator '^@' "$file" | \
        grep -v '^@' | \
        tr -d '\n' | \
        wc -c
    )
    ((SEQS_TOT += SEQS))
    ((BASES_TOT += BASES))
done
echo "scale=3; $BASES_TOT / $SEQS_TOT" | bc

# Initial dereplication for all files
for file in 3_mergereads/*fastq; do
    id=$(echo "$file" | cut -d'/' -f 2 | cut -d'.' -f 1)
    ~/Tools/installs/vsearch/bin/vsearch \
    --fastx_uniques $file \
    --strand plus \
    --sizeout \
    --relabel $id \
    --fasta_width 0 \
    --fastaout 4_precluster/${id}.derep.fasta
done

# Compare number of reads in input vs output file
# Number of reads in input
cat 3_mergereads/CT_A.fastq | paste - - - - | cut -f 2 | wc -l
# Number of reads in output
grep "^>" 4_precluster/CT_A.derep.fasta | \
sed 's/.*size=\([0-9]*\).*/\1/' | \
awk '{sum+=$1} END {print sum}'

# Pool reads
for file in 4_precluster/*; do
    cat "$file" >>4_precluster/all_combined.fasta
done

# Question 22
# Check the number of unique reads in the resulting file
grep -cv '^>' 4_precluster/all_combined.fasta

# Check total number of reads
grep '^>' 4_precluster/all_combined.fasta | \
cut -d'=' -f 2 | \
awk '{sum += $1} END {print sum}'

# Compare to number of total reads in the fastq files
for file in 3_mergereads/*.fastq; do
    cat $file | paste - - - - | cut -f -2 | wc -l
done | awk '{sum += $1} END {print sum}'

# Dereplicate pooled reads file
~/Tools/installs/vsearch/bin/vsearch \
--derep_fulllength 4_precluster/all_combined.fasta \
--sizein \
--sizeout \
--fasta_width 0 \
--uc 4_precluster/all_derep.uc \
--output 4_precluster/all_derep.fasta

# Question 24
# Check how many times the most frequent read appears
head -n 1 4_precluster/all_derep.fasta | cut -d'=' -f 2

# Question 25
# Calculate the number of reads from each sample
# Get IDs
grep '^>' 4_precluster/all_derep.fasta | \
cut -d'>' -f 2 | \
sed 's/[0-9].*//' | \
sort | \
uniq | \
# Calculate number of reads per sample
while read line; do
    # echo $line
    grep $line 4_precluster/all_derep.fasta | \
    cut -d'=' -f 2 | \
    awk '{sum += $1} END {print sum}'
done # | awk '{sum += $1} END {print sum}'

# Check that we still have the same number of total reads
grep '^>' 4_precluster/all_derep.fasta | \
cut -d'=' -f 2 | \
awk '{sum += $1} END {print sum}'

# Precluster
~/Tools/installs/vsearch/bin/vsearch \
--cluster_size 4_precluster/all_derep.fasta \
--id 0.97 \
--strand plus \
--sizein \
--sizeout \
--fasta_width 0 \
--uc 4_precluster/all_preclust.uc \
--centroids 4_precluster/all_preclust.fasta

# Question 27
# Get number of fasta entries after preclustering
grep -vc '^>' 4_precluster/all_preclust.fasta

# Get number of different record types in the first column
cat 4_precluster/all_preclust.uc | cut -f 1 | sort | uniq -c

# Question 28
# Get the number of centroids in the file
grep -c '^C' 4_precluster/all_preclust.uc

# De novo chimera checking
~/Tools/installs/vsearch/bin/vsearch \
--uchime3_denovo 4_precluster/all_preclust.fasta \
--threads 8 \
--sizein \
--sizeout \
--fasta_width 0 \
--nonchimeras 5_chimera/all.denovo.nonchimeras.fasta \
--chimeras 5_chimera/all.denovo.chimeras.fasta \
--uchimeout 5_chimera/all.denovo.uchime

# Question 32
# Calculate percentage of reads classified as chimeric
cut -f 18 5_chimera/all.denovo.uchime | \
sort | \
uniq -c | \
awk '/Y/ {y=$1} /N/ {n=$1} END {print y/(n+y)*100}'

# Unzip db
unzip -p db/silva.gold.bacteria.zip | \
sed -e "s/[.-]//g" > db/gold.fasta

# Question 33
# Check how many sequences the database contains and the average sequence length
nlines=$(grep -cv '^>' db/gold.fasta)
nchars=$(grep -v '^>' db/gold.fasta | tr -d '\n' | wc -c)
echo $nlines
echo "$nchars / $nlines" | bc

# Reference-based chimera checking
~/Tools/installs/vsearch/bin/vsearch \
--uchime_ref 5_chimera/all.denovo.nonchimeras.fasta \
--db db/gold.fasta \
--sizein \
--sizeout \
--fasta_width 0 \
--nonchimeras 5_chimera/all.ref.nonchimeras.fasta \
--chimeras 5_chimera/all.ref.chimeras.fasta \
--uchimeout 5_chimera/all.ref.uchime

# Question 35
# # Calculate percentage of discarded reads during reference checking
cut -f 18 5_chimera/all.ref.uchime | \
sort | \
uniq -c | \
awk '/Y/ {y=$1} /N/ {n=$1} END {print y/(n+y)*100}'

# Extract all reads belonging to non-chimeric preclusters
# all_derep.fasta: all reads dereplicated across colonies
# all_preclust.uc: information about the clustering step
# all.ref.nonchimeras.fasta: preclusters classified
# as non chimeric
./map.pl \
4_precluster/all_derep.fasta \
4_precluster/all_preclust.uc \
5_chimera/all.ref.nonchimeras.fasta > \
6_clustering/all.nonchimeras.derep.fasta

# Next, we extract all non-chimeric reads
# all_combined.fasta: the starting set of reads
# all_derep.uc: information about the dereplication step
# all.nonchimeras.derep.fasta: dereplicated sequences
# classified as non-chimeric (from previous step)
./map.pl \
4_precluster/all_combined.fasta \
4_precluster/all_derep.uc \
6_clustering/all.nonchimeras.derep.fasta > \
6_clustering/all.nonchimeras.fasta

# Question 39
# Calculate number of non-chomeric preclusters
grep -cv '^>' 6_clustering/all.nonchimeras.fasta
# Calculate number of dereplicated reads
grep '^>' 6_clustering/all.nonchimeras.derep.fasta | \
cut -d'=' -f 2 | \
awk '{sum += $1} END {print sum}'
# Calculate number of raw reads
grep '^>' 6_clustering/all.nonchimeras.fasta | \
cut -d'=' -f 2 | \
awk '{sum += $1} END {print sum}'

# Rename fasta headers
sed "s/[0-9]\+;/;/" 6_clustering/all.nonchimeras.fasta > \
6_clustering/all.nonchimeras.renamed.fasta

# Cluster
~/Tools/installs/vsearch/bin/vsearch \
--cluster_size 6_clustering/all.nonchimeras.renamed.fasta \
--threads 8 \
--id 0.97 \
--strand plus \
--sizein \
--sizeout \
--fasta_width 0 \
--relabel OTU_ \
--mintsize 3 \
--uc 6_clustering/final.uchime \
--centroids 6_clustering/otus.fasta \
--otutabout 6_clustering/otus.tsv

# Count the total number of OTUs
grep -c '^>' 6_clustering/otus.fasta
# Count the number of sequences they represent
grep '^>' 6_clustering/otus.fasta | \     
cut -d'=' -f 2 | \
awk '{sum += $1} END {print sum}'

# Question 43
# Count OTUs per colony
for col in {2..8}; do
    head -n 1 6_clustering/otus.tsv | cut -f $col
    tail -n +2 6_clustering/otus.tsv | \
    cut -f $col | \
    awk '{sum += $1} END {print sum}'
done # | awk '{sum += $1} END {print sum}'

# Question 44
# Count mean number of sequences per OTUs per colony
for col in {2..8}; do
    head -n 1 6_clustering/otus.tsv | cut -f $col
    tail -n +2 6_clustering/otus.tsv | \
    cut -f $col | \
    awk '{sum += $1; count++} END {print sum/count}'
done

# Run rdp classifier
java -Xmx1g -jar ~/Tools/installs/rdp_classifier_2.14/dist/classifier.jar \
-c 0.8 \
-f fixrank \
-o 7_classify/all.fixedRank \
-h 7_classify/all.significant \
6_clustering/otus.fasta

# Question 48
# Check how many sequences were not classified as bacteria
cat 7_classify/all.fixedRank | \
cut -f 3 | \
sort | \
uniq -c | \
grep -v 'Bacteria' | \
awk '{sum += $1} END {print sum}'

# Check how many OTUs could be determined on the phylym level (at or above 0.8 confidence)
awk '$7 >= 0.8' 7_classify/all.fixedRank | wc -l

# Question 49
# Check how many OTUs could be determined on the genus level (at or above 0.8 confidence)
awk '$19 >= 0.8' 7_classify/all.fixedRank | wc -l

# Question 51
# Trim classification data
echo 'OTU,Phylum' > 7_classify/all_trim.fixedRank.csv
awk '$7 >= 0.8' 7_classify/all.fixedRank | \
awk '$2 ~ /Bacteria/' | \
awk '{ sub(/;.*/, "", $1); print $1 "," $5}' >> \
7_classify/all_trim.fixedRank.csv