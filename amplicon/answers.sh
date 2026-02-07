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
# done

# Get percent discarded reads
for file in 2_trimming/*U.fastq; do
    echo $file | sed s/.fastq//
done