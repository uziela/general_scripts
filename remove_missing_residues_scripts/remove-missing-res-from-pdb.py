#!/usr/bin/env python

# Written by Karolis Uziela in 2014

import sys
from Bio import AlignIO
from sets import Set

################################ Usage ################################

script_name = sys.argv[0]

usage_string = """
Usage:

    %s [Parameters]
    
Parameters:

    <input-file> - input pdb
    <input-needle> - needle alignment between model and native
    <output-file> - output pdb
""" % script_name

if len(sys.argv) != 4:
    sys.exit(usage_string)

################################ Functions ################################

def remove_res(filename, to_remove):
    out_str = ""
    f = open(filename)
   
    res_index = 0
    last_index = ""
    while True:
        line = f.readline()
        if len(line) == 0: 
            break
        #line = line.rstrip('\n')
        if line[:4] == "ATOM":
            cur_index = line[22:27]
            if last_index != cur_index:
                res_index += 1
                last_index = cur_index
            if not (res_index in to_remove):
                out_str += line
        else:
            out_str += line
            #print line
        #bits = line.split("\t")     
        
    f.close()
    return out_str
    
def write_data(output_file, out_str):
    f = open(output_file,"w")  
    #out_str = "%s %f \n" % str_var f_var
    f.write(out_str)    
    f.close()


################################ Variables ################################

# Input files/directories
input_pdb_file = sys.argv[1]
input_needle_file = sys.argv[2]

# Output files/directories
output_pdb_file = sys.argv[3]

# Constants
# N/A

# Global variables
# N/A

################################ Main script ################################
    
#sys.stderr.write("%s is running with arguments: %s\n" % (script_name, str(sys.argv[1:])))

align = AlignIO.read(input_needle_file, "emboss")

# Read alignment
my_seq = []
for record in align:
    my_seq.append(str(record.seq))
    #seqid = record.id

model_seq = my_seq[0]
native_seq = my_seq[1]

#model_seq="-AB-AA"
#native_seq="BA-BA-"

#print model_seq
#print native_seq

model_index = 0
to_remove = Set()
for i in range(len(model_seq)):
    if model_seq[i] != "-":
        model_index += 1
    if model_seq[i] != "-" and model_seq[i] != native_seq[i]:
        to_remove.add(model_index)

#print to_remove

out_str = remove_res(input_pdb_file, to_remove)

write_data(output_pdb_file, out_str)

#sys.stderr.write("%s done.\n" % script_name)



