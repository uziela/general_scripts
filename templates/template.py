#!/usr/bin/env python

# Written by Karolis Uziela in 2024

import sys
import argparse
import os
from IPython import embed
import cv2
import numpy as np

################################ Functions ####################################

def get_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser()
    #parser.add_argument("input_file", help="Input file", type=str)
    parser.add_argument("input_dir", help="Input directory", type=str)
    parser.add_argument("output_file", help="Output file", type=str)
    parser.add_argument("-v", "--verbose", help="increase output verbosity",
                    action="store_true")
    return parser.parse_args()

def read_file(input_file):
    """Read file line by line and do... something"""
    with open(input_file) as f:
        while True:
            line = f.readline()
            if len(line) == 0:
                break
            line = line.rstrip('\n')
            #print(line)
            #bits = line.split("\t")


def write_file(output_file, out_str):
    """Write out_str to output_file"""
    with open(output_file, "w") as f:
        f.write(out_str)

def list_directory(input_dir, ends_with=""):
    """ List files in a directory 
    Arguments:
        input_dir -- directory to read
        ends_with -- list only files whose filename end match "ends_with" 
                     pattern (optional)
    """
    files = []
    for f in os.listdir(input_dir):
        if os.path.isfile(os.path.join(input_dir, f)) and \
                          f.endswith(ends_with):
            files.append(os.path.join(input_dir, f))
    return files

def load_image_into_numpy_array(image_path):
    image_np = cv2.imread(image_path, cv2.IMREAD_COLOR)
    if image_np is None:
        return None, (400, 'Unsupported image format.')
    image_np = cv2.cvtColor(image_np, cv2.COLOR_BGR2RGB)
    return image_np

def main():
    return

###################### Global constants and Variables #########################

# Global constants
# N/A

# Global variables
# N/A

################################ Main script ##################################
    
if __name__ == '__main__':
    args = get_arguments()
    if args.verbose: 
        # When the script starts, print an information message with the name 
        # of the script and its  arguments
        sys.stderr.write("{} started running with arguments: {}\n".format(
            sys.argv[0], ' '.join(sys.argv[1:])))

    #print(list_directory(args.input_dir, ends_with=".csv"))
    main()

    if args.verbose:
        # Print another information message when the script finishes
        sys.stderr.write("{} done.\n".format(sys.argv[0]))



