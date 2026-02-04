# Snakemake Exercise Questions 4–5

### Oliver E. Todreas

## Question 4

The file `./Q4-5/Snakefile` is a workflow that takes a file with any name and the extension `.0` and creates two files with the same name, one with the extension `.1` and one with the extension `.2`.

## Question 5

The file `./Q4-5/Snakefile` satisfies the requirements of question 5 as well as question 4.

The effect of calling `expand` in rules other than `all` has little effect here. The only difference is that when using expand, each rule will be run once for each argument in the list, in succession. Without `expand`, you aren't parsing through a Python list, but rather passing any pattern. As far as I can tell, for this particular program, both behave similarly.

## Question 10

This directory contains the reproducible Snakemake build to run analyses that ultimately create a `.vcf` file. To reproduce this, you must run it in an environment containing Snakemake. You can create this environment by running

```sh
conda create -n snakemake -c conda-forge -c bioconda snakemake
conda activate snakemake
```

Then, run `./workflow/Snakefile` by calling

```sh
snakemake -p --software-deployment-method conda -j2
```

### Notes

I created the files `./results/00_mapped_reads/.gitkeep` and `./results/01_called_variants/.gitkeep` to make sure the empty folders got added to my git commits when working, and they are still there for safety

I also had to make some changes to the `.yaml` files in `./workflow/envs/` because the older versions of the software that the exercise requested I install were not supported. There are inline comments in the files in question.