if [ -f Snakefile ]; then
    rm my_first_workflow* manual_target*
    touch my_first_workflow.0
    snakemake --cores 1
    touch manual_target.0
    snakemake --cores 1 manual_target.2
else
    echo 'Please `cd` into `./Q4-5`.'
fi