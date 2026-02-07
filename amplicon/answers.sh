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

# # Run FastQC on all `fastq` files
# for file in Colonies/*.fastq; do
#     fastqc "$file" -o 1_fastqc/
# done

# # Run trimmomatic on all `fastq` files
# ls Colonies/*_1.fastq | \
# sed s/_1.fastq// | \
# while read line; do 
#     id=$(echo $line | sed "s/.*\///")
#     java -jar ~/Tools/installs/Trimmomatic-0.40/trimmomatic-0.40.jar PE \
#     -threads 8 \
#     -trimlog 2_trimming/$id.log \
#     -baseout 2_trimming/$id.fastq \
#     ${line}_1.fastq \
#     ${line}_2.fastq \
#     LEADING:20 TRAILING:20 SLIDINGWINDOW:8:15 MINLEN:140 AVGQUAL:20
# done > 2_trimming/trimmomatic_all.log 2>&1

# # Question 14
# # Get a rough idea of how many sequences were dropped during trimming
# grep 'Dropped: ' 2_trimming/trimmomatic_all.log | \
# awk -F'Dropped: ' '{ print $2 }'

# # Question 15
# # Run FastQC on all `fastq` files
# for file in 2_trimming/*.fastq; do
#     fastqc "$file" -o 2_trimming/fastqc_trimmed/
# done

# # Open fastqc reports (use zsh locally)
# open \
# 1_fastqc/CT_A_1_fastqc.html \
# 2_trimming/fastqc_trimmed/CT_A_1P_fastqc.html \
# 1_fastqc/CT_C_2_fastqc.html \
# 2_trimming/fastqc_trimmed/CT_C_2P_fastqc.html \
# 1_fastqc/MA_A_2_fastqc.html \
# 2_trimming/fastqc_trimmed/MA_A_2U_fastqc.html

# Run pandaseq
for file in 2_trimming/*P.fastq; do
    id=$($file | cut -d'/' -f2 | cut -d'_' -f1-2)
    echo $id
    # pandaseq \
    # -f 2_trimming/CT_A_1P.fastq \
    # -r 2_trimming/CT_A_2P.fastq \
    # -g 3_mergereads/CT_A.log \
    # -u 3_mergereads/CT_A.unaligned.fasta \
    # -w 3_mergereads/CT_A.fastq \
    # -F
done