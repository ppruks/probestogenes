#!/usr/bin/perl

use strict;
use warnings;

# Sort files by chromosome number, chromosome start and chrosome end 

my @sort_annotation = ( "sort", "-k2", "-o", "../../data/expression/sorted_annotation.txt", $ARGV[0] );
my @sort_rohgenes = ( "sort", "-k4","-k5","-k6", "../../data/expression/sorted_rohgenes", $ARGV[1] );

# Create empty hash for probe to haplotype matching

my %probes_to_rohgenes = ();

# Open rohgenes stream 

open my $rohgenes, "<", "../../data/expression/sorted_rohgenes.txt" or die $!;

# Skip header line 

my @rohgenes_header = <$rohgenes>;
shift @rohgenes_header;

# For every line in the rohgenes stream:

while( my $rohgenes_line = <$rohgenes> ) {

	# Split line and store variables
	my ( $roh_haplotype, $roh_gene_name, $roh_chr, $roh_chr_start, $roh_chr_end, $roh_strand) =  split /[ \t]/, $rohgenes_line;

	# Open annotation file stream
	open my $annotation, "<", "../../data/expression/sorted_annotation.txt" or die $!;

	# Skip header line
	my @annotation_header = <$annotation>;
	shift @annotation_header;

	while(my $annotation_line = <$annotation>) {
		
		# Split line and store variables
		my ( $platform, $annotation_probenumber, $annotation_gene_name, $annotation_chr, $annotation_chr_start, $annotation_chr_end, $annotation_probe, $annotation_seq ) = split /[ \t]/, $annotation_line;
		
		# Keep looking if annotation chromosome number is less than roh chromosome number
		if( $annotation_chr <= roh_chr ) {

			#------------------------------------------- 

			# If roh file chromosome number, start and match those of annotation file's, then... NEED TO STORE roh genedata in an array!
			if ( $roh_chr == $ annotation_chr && $roh_chr_start == $annotation_chr_start && $roh_chr_end == $roh_chr_end ) {

			}


		} else {
			last;
		}
	}
}

# 	1) open annotation file stream 
#	2) skip header line
# 	3) find line that matches on chromosome number
#	4) if matches on chromosome number: find line that matches on chromosome start and chromosome end
#	5) if doesn't match on chromosome number: break;
#	6) if matches on chromosome start and end: hash probe number (key) in annotation file to haplotype number in gene file (value)




