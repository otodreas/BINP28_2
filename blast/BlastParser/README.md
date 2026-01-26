# BLAST Parser

```sh
OliverTodreas_blastParser.py input.blastp output.tsv
```

This is a CLI app that takes a BLAST alignment and returns a `.tsv` file with information

#query | target | e-value | identity (%) | score
--- | --- | --- | --- | ---
YAL016C-B |  |  |  |  |
YAL016W | Paxin1_152130 | 5e-156 | 43 | 476

When a query returns multiple hits, all the queries with alignment scores will be shown.