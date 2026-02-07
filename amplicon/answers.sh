# # Questions 7 & 8
# # Loop through colonies fastq files and check number of reads and average read length
# SEQS_TOT=0
# BASES_TOT=0
# for file in Colonies/*.fastq; do
#     SEQS=$(grep -c '^@' "$file")
#     BASES=$(
#         grep -A 1 --no-group-separator '^@' "$file" | \
#         grep -v '^@' | \
#         tr -d '\n' | \
#         wc -c
#     )
#     ((SEQS_TOT += SEQS))
#     ((BASES_TOT += BASES))
# done
# echo $SEQS_TOT
# echo "scale=3; $BASES_TOT / $SEQS_TOT" | bc

# Run FastQC on all `fastq` files
for file in Colonies/*.fastq; do
    fastqc "$file" -o 1_fastqc/
done