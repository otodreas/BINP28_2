# BLAST Parser


# IMPORT LIBRARIES
# ================

import argparse
import os
import sys


# DEFINE FUNCTIONS
# ================

class File_Reader_Writer:
    def __init__():
        pass

    def write_header(output_file):
        head = ["#query", "target", "e-value", "identity (%)", "score"]
        output_file.write("\t".join(head))

    def file_reader(input_file):
        pass

    def _query_loop():
        pass

    def _target_loop():
        pass


# PARSE INPUTS
# ============

# Define argument parser
parser = argparse.ArgumentParser(
    prog="blastParser",
    description="This program takes a blastp output as input and summarizes the data and outputting a .tsv file.",
    epilog="blastParser, Oliver E. Todreas, Lund University, 2026",
)

# Define arguments
parser.add_argument("input")
parser.add_argument("output")

# Define an argparce.Namespace object
args = parser.parse_args()

# Get real paths of input and output files
input = os.path.realpath(args.input)
output = os.path.realpath(args.output)

# Handle erraneous inputs
if not os.path.isfile(input):
    sys.exit("Input file does not exist.")
elif not output.endswith(".tsv") and not output.endswith(".txt"):
    sys.exit("Output file must be .tsv or .txt")
elif not os.path.isdir(os.path.dirname(output)):
    sys.exit("Output directory does not exist.")
elif os.path.isfile(output):
    print(f"Output file\n{output}\nwas overwritten.")


# WRITE OUTPUT FILE
# =================

# Write and clear output file and open it to append lines
open(output, "w")
f_out = open(output, "a")

write_header(f_out)

# Open input file and read lines one by one
with open(input, "r") as f_in:
    for line in f_in:
        """
        File read loop
        Read the entire file
        """
        # Define row as a list with the query in the first position
        if line.startswith("Query= "):
            row = [line.split()[1]] + [""] * 4
            for line in f_in:
                """
                Query loop
                Enter when query is identified
                """
                # If no hits are found, write the mostly empty line to the file
                if line.startswith("***** No hits found *****"):
                    f_out.write("\n" + "\t".join(row))
                    # Break into file read loop
                    break
                # Identify a hit
                elif line.startswith(">"):
                    # Extract target sequence
                    row[1] = line.strip()[1:]
                    for line in f_in:
                        """
                        Target loop
                        Enter when target is identified
                        """
                        # Identify line with score and e-value
                        if "Score = " and "Expect = " in line:
                            # Insert e-value without trailing comma into row
                            row[2] = line.split()[7][:-1]
                            # Insert score into row
                            row[4] = line.split()[2]
                        # Identify line with identity
                        elif "Identities = " in line:
                            # Insert identity without parenthesis and comma
                            row[3] = line.split()[3][1:-2]
                            # Write complete row and break into query loop
                            f_out.write("\n" + "\t".join(row))
                            # Break into query loop
                            break
                # Write query into row list to not miss any queries
                elif line.startswith("Query= "):
                    row = [line.split()[1]] + [""] * 4
                    # Stay in query loop since a query has been identified

# Close output file
f_out.close()


# RUN PROGRAM
# ===========


# Check for empty output file
with open(output, "r") as f_out_read:
    if not f_out_read.readline():
        print("WARNING: output file empty")
