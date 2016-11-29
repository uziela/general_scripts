#!/usr/bin/env python

# Written by Karolis Uziela in 2016

import sys
import re

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

def esc(mystring): # escape underscore
    return re.sub("_", "\_", mystring)

def read_data(filename):
    
    first = True
    N = 0
    f = open(filename)
    out_str = ""
    while True:
        line = f.readline()
        if len(line) == 0: 
            break
        line = line.rstrip('\n')
        bits = line.split(",")
        if first:
            N = len(bits)
            out_str += "\\begin{table}[!ht]\n"
            out_str += "\centering\n"
            out_str += "\caption{{\\bf Mytitle }}\n"
            out_str += "\\begin{tabular}{"
            for i in range(N):
                out_str += "|l"
            out_str += "|}\n"
            out_str += "\hline\n"
            for i in range(1,N):
                #out_str += " & \\textbf{\\verb$" + bits[i] + "$}"
                #out_str += " & \\textbf{" + esc(bits[i]) + "}"
                out_str += " & " + esc(bits[i])
            out_str += " \\\\ \n"
            first = False
        else:
            #out_str += "\hline\n"
            #out_str += "\\textbf{\\verb$" + bits[0] + "$}"
            #out_str += "\\textbf{" + esc(bits[0]) + "}"
            out_str += esc(bits[0]) 
            for i in range(1,N):
                #out_str += " & \\verb$" + bits[i] + "$"
                out_str += " & " + esc(bits[i])
            out_str += " \\\\ \n"
    out_str += "\hline\n"
    out_str += "\end{tabular}\n"
    out_str += "\label{table:mylabel}\n"
    out_str += "\end{table}"
        
    f.close()
    return out_str
    
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

out_str = read_data(input_file)

write_data(output_file, out_str)

sys.stderr.write("%s done.\n" % script_name)



