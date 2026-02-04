# Snakemake Exercise Question 10

Create and activate environment:

```sh
conda create -n snakemake -c conda-forge -c bioconda snakemake
conda activate snakemake
```

Run `./workflow/Snakefile` by calling

```sh
snakemake -p --software-deployment-method conda -j2
```