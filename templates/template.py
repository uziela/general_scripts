#!/usr/bin/env python

# Written by Karolis Uziela in 2016

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

def read_data(filename):
    
    f = open(filename)
    
    while True:
        line = f.readline()
        if len(line) == 0: 
            break
        line = line.rstrip('\n')
        #bits = line.split("\t")     
        
    f.close()
    
def write_data(output_file, out_str):
    f = open(output_file,"w")  
    #out_str = "%s %f \n" % str_var f_var
    f.write(out_str)    
    f.close()


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



