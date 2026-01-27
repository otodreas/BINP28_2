# BLAST Parser

import sys

inpath = sys.argv[1]
outpath = sys.argv[2]

open(outpath, 'w')
out = open(outpath, 'a')

head = ['#query', 'target', 'e-value', 'identity (%)', 'score']
out.write('\t'.join(head) + '\n')

n = 0
row = []

with open(inpath, 'r') as f:
    for line in f:
        if line.startswith('Query= '):
            q = line.split()[1]
            for line in f:
                row = [q]
                if line.startswith('>'):
                    row = [q]
                    row.append(line.strip()[1:])
                elif line.startswith('***** No hits found *****'):
                    break
                
                elif line.startswith('Query= '):
                    q = line.split()[1]
                out.write('\t'.join(row) + '\n')
                    # break
                    
                    # for line in f:
                    #     if line.startswith('Score = '):
                    #         row.append(line.split()[7])
                    #         row.append(0)
                    #         row.append(line.split()[2])
                    #         next
                    #         row[3] = line.split()[3]

out.close()
