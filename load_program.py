#!/usr/local/bin/python
""" create a memory hex file that begins with a hex file and ends with all
0's
optional command line aguments: first argument is the output file,
second argument is the input file.
defaults to reading program.hex and outputting to mem.hex
"""

import sys

# open the files representing the memory and the program
o_name = "mem.hex"
i_name = "program.hex"
# parse command line inputs if they exist
if len(sys.argv) > 2:
    o_name = sys.argv[1]
    i_name = sys.argv[2]

f_mem = open(o_name, "w")
f_program = open(i_name, "r")

# read the program into memory, with a limit of 128 lines
count = 0;
for line in f_program:
    f_mem.write(line)
    count = count + 1
    if count == 128:
        break

# pad the rest of the memory with 0's
for i in range(count, 128):
    f_mem.write("00000000\n")

# close the files
f_mem.close()
f_program.close()

