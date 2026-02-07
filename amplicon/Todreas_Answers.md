# Amplicon Exercise Answers
### Oliver E. Todreas

## Answers to questions

1. **45** samples were taken across colonies. For the caste analysis, 19 samples were taken across all 7 colonies, meaning that a total of **133** samples were taken.
2. ***Spirochaetes*** is the most abundant phylum in the termite microbiota
3. The hindgut microbiota **did not differ significantly** between castes.
4. The `fastq` files take up **1.3066 GB** and the `xml` files take up **252 KB**.
5. The location specified by the coordinates are in **Kyrgyzstan**.
6. In this study, we want exactly two reads per individual. To ensure this is the case, we can
    - Check that each directory contains two `fastq` files where the first line of each `fastq` file is identical except for the number following the space: for one file, the character should be `1`, and the other, the character should be `2`. Only use the directories whose content match these conditions.
7. There are **7,856,118 sequences** across the `fastq` files.
8. There are an average of **227.5 bases per read** across the `fastq` files.
9. The `- - - -` in `paste` is **merging four lines into one** from the input files into a single line, returning a matrix of sorts, with four columns and the cumulative number of rows of all files being searched with `grep` divided by four.
10. The second line is cutting out all columns but the second (corresponding with the sequences) and then performing a Perl-compatible regular expression `grep`, where each line must start with `TTAGA`, be followed by a `C` or `G`, and then be followed by `AC`.

**Continued on google docs**