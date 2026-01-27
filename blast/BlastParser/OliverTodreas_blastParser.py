# BLAST Parser

# Import libraries
import sys

# Get inputs
inpath = sys.argv[1]
outpath = sys.argv[2]

# Write and clear output file and open it to append lines
open(outpath, 'w')
out = open(outpath, 'a')

# Define header and write it to the output file
head = ['#query', 'target', 'e-value', 'identity (%)', 'score']
out.write('\t'.join(head))

# Open input file and read lines one by one
with open(inpath, 'r') as f:
    """
    File read loop
    Read the entire file
    """
    for line in f:
        # Define row as a list with the query in the first position
        if line.startswith('Query= '):
            row = [line.split()[1]] + [''] * 4
            """
            Query loop
            Enter when query is identified
            """
            for line in f:
                # If no hits are found, write the mostly empty line to the file
                if line.startswith('***** No hits found *****'):
                    out.write('\n' + '\t'.join(row))
                    # Break into file read loop
                    break
                # Identify a hit
                elif line.startswith('>'):
                    # Extract target sequence
                    row[1] = (line.strip()[1:])
                    """
                    Target loop
                    Enter when target is identified
                    """
                    for line in f:
                        # Identify line with score and e-value
                        if 'Score = ' and 'Expect = ' in line:
                            # Insert e-value without trailing comma into row
                            row[2] = line.split()[7][:-1]
                            # Insert score into row
                            row[4] = line.split()[2]
                        # Identify line with identity
                        elif 'Identities = ' in line:
                            # Insert identity without parenthesis and comma
                            row[3] = line.split()[3][1:-2]
                            # Write complete row and break into query loop
                            out.write('\n' + '\t'.join(row))
                            # Break into query loop
                            break
                # Write query into row list to not miss any queries
                elif line.startswith('Query= '):
                    row = [line.split()[1]] + [''] * 4
                    # Stay in query loop since a query has been identified

# Close output file
out.close()
