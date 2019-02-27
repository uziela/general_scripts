#!/usr/bin/env python

# Written by Karolis Uziela in 2019

import sys

################################ Usage ################################

script_name = sys.argv[0]

usage_string = """
Usage:

    %s [Parameters]
    
Parameters:

    <input-file> - input file
    <output-file> - output file
""" % script_name

if len(sys.argv) != 3:
    sys.exit(usage_string)

################################ Functions ################################

def read_data(input_file):
    
    with open(input_file) as f: 
        while True:
            line = f.readline()
            if len(line) == 0: 
                break
            line = line.rstrip('\n')
            #print(line)
            #bits = line.split("\t")     
        
    
def write_data(output_file, out_str):
    with open(output_file, "w") as f:
        f.write(out_str)    


################################ Variables ################################

# Input files/directories
input_file = sys.argv[1]

# Output files/directories
output_file = sys.argv[2]

# Constants
# N/A

# Global variables
# N/A

################################ Main script ################################
    
sys.stderr.write("%s is running with arguments: %s\n" % (script_name, str(sys.argv[1:])))

sys.stderr.write("%s done.\n" % script_name)



