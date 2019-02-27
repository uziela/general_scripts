#!/usr/bin/env Rscript

# Written by Karolis Uziela in 2019

cargs <- commandArgs(trailingOnly = TRUE)

input_file <- cargs[1]

script_name <- basename(sub(".*=", "", commandArgs()[4]))

# ---------------------- Main script ------------------------- #

write(paste(script_name, "is running with arguments:"), stderr())
write(paste(" ", cargs), stderr())
write("----------------------- Output ---------------------", stderr())

write(paste(script_name, "is done."), stderr())
