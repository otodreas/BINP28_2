# BLAST Parser

```sh
OliverTodreas_blastParser.py input.blastp output.tsv
```

This is a CLI app for python 3.14.0 that takes a BLAST alignment and returns a `.tsv` or `.txt` file with information

#query | target | e-value | identity (%) | score
--- | --- | --- | --- | ---
YAL016C-B |  |  |  |  |
YAL016W | Paxin1_152130 | 5e-156 | 43 | 476

When a query returns multiple hits, all the queries with alignment scores will be shown. If there are multiple candidate alignments for a query-target pair, only the first (assumed to be the highest scoring) is reported. This makes lookup of the alignment easy and reduces clutter.

Detailed information on the script can be found in the docstrings in `OliverTodreas_blastParser.py`.

## To look up a hit:

Get the query and the target from the output file and input them into the pipeline

```sh
sed -n '/Query= {query}/,$p' alignments.blastp | sed -n '/>{target}/,$p' | head -n 40
```

Adjust the number of lines shown by `head` based on the length of the sequence