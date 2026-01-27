"""
OliverTodreas_blastParser
Oliver Todreas
Lund University 2026

A CLI tool that takes a blastp alignment as input and writes a .tsv summary
file with information on a query-target pair's e-value, identity %, and score.
"""


# IMPORT LIBRARIES
# ================

import argparse
import os
import sys


# DEFINE FUNCTIONS
# ================


def main():
    """
    Run defined functions
    """

    input, output = parse_arguments()
    blastparse(input, output)
    check_output_empty(output)


def parse_arguments():
    """
    Get arguments from commandline using argparse, perform checks, and return inputs and outputs
    """

    # Define argument parser
    parser = argparse.ArgumentParser(
        prog="blastParser",
        description="A CLI tool that takes a blastp alignment as input and writes a .tsv summary file with information on a query-target pair's e-value, identity %, and score.",
        epilog="OliverTodreas_blastParser, Oliver Todreas, Lund University 2026",
    )

    # Define input
    parser.add_argument("input")

    # Define output with default value
    parser.add_argument("output", nargs="?", default="OliverTodreas_output.txt")

    # Define an argparce.Namespace object
    args = parser.parse_args()

    # Get real paths of input and output files
    input = os.path.realpath(args.input)
    output = os.path.realpath(args.output)

    # Handle erraneous inputs (too few/many arguments is handled by argparse)
    # Check if input file exists
    if not os.path.isfile(input):
        sys.exit("Input file does not exist.")

    # Check that input is a blastp file
    elif not input.endswith(".blastp"):
        sys.exit("Input file must be a .blastp file.")

    # Check output file format
    elif not output.endswith(".tsv") and not output.endswith(".txt"):
        sys.exit("Output file must be .tsv or .txt")

    # Check that the directory to which the user wants to write exists
    elif not os.path.isdir(os.path.dirname(output)):
        sys.exit("Output directory does not exist.")

    # Alert the user of overwriting
    elif os.path.isfile(output):
        print(f"Output file\n{output}\nwas overwritten.")

    # Return real paths to input and output files
    return input, output


def blastparse(in_file, out_file):
    """
    Build output file line by line using input data
    - Initialize and open output file
    - Write header to output file
    - Open input file and read line by line in the `file read loop`, defining lists that get written to rows
        - Enter the `query loop` if a query is found
            - If no matches are found
                - Write the row as is to the output file
                - Break out of the `query loop`
            - If a match is found
                - Insert them into a new row using the `>` character as an identifier
                - Enter the `target loop`
                    - Insert score, e-value, and identity % into the row
                    - Write the row to the output file
                    - Break out of the `target loop`
            - If new query is found
                - Insert it into a new, empty row list
                - Do not break out of the `query loop`
    - Close the output file

    :param in_file: Input file's "real path" as defined by `os.path.realpath()`
    :param out_file: Output file's "real path" as defined by `os.path.realpath()`
    """

    # Write and clear output file and open it to append lines
    open(out_file, "w")
    f_out = open(out_file, "a")

    # Define header and write it to the output file
    head = ["#query", "target", "e-value", "identity (%)", "score"]
    f_out.write("\t".join(head))

    # Open input file and read lines one by one
    with open(in_file, "r") as f_in:
        # Enter file read loop
        for line in f_in:
            # Define row as a list with the query in the first position
            if line.startswith("Query= "):
                row = [line.split()[1]] + [""] * 4
                # Enter query loop
                for line in f_in:
                    # If no hits are found, write the mostly empty line to the file
                    if line.startswith("***** No hits found *****"):
                        f_out.write("\n" + "\t".join(row))
                        # Break into file read loop
                        break

                    # Identify a hit
                    elif line.startswith(">"):
                        # Extract target sequence
                        row[1] = line.strip()[1:]
                        # Enter target loop
                        for line in f_in:
                            # Identify line with score and e-value
                            if "Score = " and "Expect = " in line:
                                # Insert e-value without trailing comma into row
                                row[2] = line.split()[7][:-1]
                                # Insert score into row
                                row[4] = line.split()[2]
                            # Identify line with identity
                            elif "Identities = " in line:
                                # Insert identity without parenthesis, %, and comma
                                row[3] = line.split()[3][1:-3]
                                # Write complete row and break into query loop
                                f_out.write("\n" + "\t".join(row))
                                # Break into query loop
                                break

                    # Write query into row list to not miss any queries
                    elif line.startswith("Query= "):
                        row = [line.split()[1]] + [""] * 4
                        # Stay in query loop since a query has been identified

    # Close the output file
    f_out.close()


def check_output_empty(out_file):
    """
    Check if the output file that was written is empty

    :param out_file: Output file's "real path" as defined by `os.path.realpath()`
    """

    # Open the output file, read the first line, print warning if it's empty
    with open(out_file, "r") as f_out_read:
        if not f_out_read.readline():
            print("WARNING: output file empty")


# RUN PROGRAM
# ===========

if __name__ == "__main__":
    main()
