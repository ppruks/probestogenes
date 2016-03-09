#!/usr/bin/perl

use strict;
use warnings;

# Sort files by chromosome number, chromosome start and chrosome end 

my @sort_annotation = ("sort", "-k2", "-o", "../../data/expression/sorted_annotation.txt", $ARGV[0]);
my @sort_rohgenes = ("sort", "-k2", "../../data/expression/sorted_rohgenes", $ARGV[1]);

# Create empty hash for probe to haplotype matching
# Open rohgenes stream and skip header line

# For every line in the stream:

# 	1) open annotation file stream 
#	2) skip header line
# 	3) find line that matches on chromosome number
#	4) if matches on chromosome number: find line that matches on chromosome start and chromosome end
#	5) if doesn't match on chromosome number: break;
#	6) if matches on chromosome start and end: hash probe number (key) in annotation file to haplotype number in gene file (value)

