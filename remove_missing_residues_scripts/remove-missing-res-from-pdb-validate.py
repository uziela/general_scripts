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

    <input-needle1> - needle alignment between model and native
    <input-needle2> - needle alignment between dis_rm and native
""" % script_name

if len(sys.argv) != 3:
    sys.exit(usage_string)

################################ Functions ################################


################################ Variables ################################

# Input files/directories
input_needle_file1 = sys.argv[1]
input_needle_file2 = sys.argv[2]

# Output files/directories

# Constants
# N/A

# Global variables
# N/A

################################ Main script ################################
    
#sys.stderr.write("%s is running with arguments: %s\n" % (script_name, str(sys.argv[1:])))


# Read alignment 1
align = AlignIO.read(input_needle_file1, "emboss")

my_seq = []
for record in align:
    my_seq.append(str(record.seq))
    #seqid = record.id

model_seq1 = my_seq[0]
native_seq1 = my_seq[1]

#print model_seq1
#print native_seq1

# Read alignment 2
align = AlignIO.read(input_needle_file2, "emboss")

my_seq = []
for record in align:
    my_seq.append(str(record.seq))
    #seqid = record.id

model_seq2 = my_seq[0]
native_seq2 = my_seq[1]

#print model_seq2
#print native_seq2

#print "========="
mod_nogaps1 = model_seq1.replace("-","")
mod_nogaps2 = model_seq2.replace("-","")

native_nogaps1 = native_seq1.replace("-","")
native_nogaps2 = native_seq2.replace("-","")

mismatches = 0
for i in range(len(model_seq1)):
    if model_seq1[i] != native_seq1[i] and model_seq1[i] != "-":
        mismatches +=1

if len(mod_nogaps1) - len(mod_nogaps2) != mismatches:
    print len(mod_nogaps1) - len(mod_nogaps2)
    print mismatches
    print "ERROR: The number of residues removed from model sequence is not equal to the number of mismatches between model and native for:",input_needle_file1
elif len(native_nogaps2) - len(native_seq2) != 0:
    print "ERROR: The native sequence still contains gaps in the new alignment for:",input_needle_file1
else:
    print "OK"

#sys.stderr.write("%s done.\n" % script_name)



