# Snakemake Exercise

## Oliver E. Todreas

# Question 4

The file `./Q4-5/Snakefile` is a workflow that takes a file with any name and the extension `.0` and creates two files with the same name, one with the extension `.1` and one with the extension `.2`.

You can reproduce my work by building and activating a conda environment according to the instructions in the exercise document and then running `./reprod_snake.sh` **from the directory `./Q4-5/`**.

# Question 5

The file `./Q4-5/Snakefile` satisfies the requirements of question 5 as well as question 4.

The effect of calling `expand` in rules other than `all` has little effect here. The only difference is that when using expand, each rule will be run once for each argument in the list, in succession. Without `expand`, you aren't parsing through a Python list, but rather passing any pattern. As far as I can tell, for this particular program, both behave similarly.