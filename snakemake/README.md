# Exercise instructions

The following files should be handed in:

- A text document with answers to the questions. Acceptable file formats are txt and md (markdown). Docx is not accepted.
- A Snakefile containing the solution for questions 4 and 5.
- A zip file containing the solution to question 10. This should consists of all the necessary files to run the workflow. The directory structure must be preserved in the zip file. Results do not need to be included.

Optionally, and potentially contributing to a higher grade, the following may also be submitted:

- An additonal Snakefile containing the solution for questions 11, 12 or 13.
- Any additional files that have been updated for question 12.
- A zip file formatted as the one previously mentioned for question 14.

# Notes

## Rules

A **rule** consists of a requested input file `input`, a requested output file `output`, and the commands used to create the output file from the input file: `shell` for shell commands and `run` for Python.

```snakemake
rule rulename:
    input:
        'input.file'
    output:
        'output.file'
    shell:
        # run shell command
```

## Target files

Snakemake wants to produce an output file. The file under the `input` in `rule all` is the file you want to produce. 

```snakemake
rule all:
    input:
        'file.name' # make this file
```

It then works backwards by looking for the rule that creates that file, and the rule that creates the input for that rule, and so on. 