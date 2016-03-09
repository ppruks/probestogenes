#!/usr/bin/perl

use strict;
use warnings;

# Sort files by chromosome number, chromosome start and chrosome end 

my @sort_annotation = ( "sort", "-k2", "-o", "../../data/expression/sorted_annotation.txt", $ARGV[0] );
my @sort_rohgenes = ( "sort", "-k4","-k5","-k6", "-o", "../../data/expression/sorted_rohgenes", $ARGV[1] );
my @sort_expression = ( "sort", "-k1", "-o", "../../data/expression/sorted_expression", $ARGV[2] );

system(@sort_annotation);
system(@sort_rohgenes);
system(@sort_expression);

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
	my @rohgenes_line =  split /[ \t]/, $rohgenes_line;

	# Open annotation file stream
	open my $annotation, "<", "../../data/expression/sorted_annotation.txt" or die $!;

	# Skip header line
	my @annotation_header = <$annotation>;
	shift @annotation_header;

	# Fill up probe to haplotype hash  

	while( my $annotation_line = <$annotation> ) {
		
		# Split line, store line in an array, get reference to array
		my @annotation_line = split /[ \t]/, $annotation_line;
		my $annotation_line_ref = \@annotation_line;
		
		# Keep looking if annotation chromosome number is less or equal to roh chromosome number
		if( $annotation_line[3] <= $rohgenes_line[3] ) {

			# If roh file's chromosome number, start and end match those of annotation file's, then add (probenumber : rohgenes_data_ref) key:value pair to hash
			if ( $rohgenes_line[3] == $ annotation_line[3] && $rohgenes_line[4] == $annotation_line[4] && $rohgenes_line[5] == $rohgenes_line[5] ) {
				%probes_to_rohgenes = {
					annotation_data[1] => $rohgenes_line_ref # map probe number to reference to rohgenes_line
				};
			}
		} else {
			last;
		}
	}
}

# Open expression file stream 

open my $expression, "<", "../../data/expression/sorted_expression.txt" or die $!;

# Skip header line

my @expression_header = <$expression>;
shift @annotation_header;

# Loop over lines of expression file and use probe number to index into probes_to_rohgenes hash and print out gene data to STDOUT

while( my $expression_line = <$expression> ) {

	# Split line and store probe number
	my @expression_line = split /[ \t]/, $expression_line;

	# Check if the hash contains the key probenumber, if yes, then index into hash, dereference and print elements of array 
	if( exists $probes_to_rohgenes{$expression_line[0]} ) {
			for my $gene_data_value (@{$probes_to_rohgenes{$expression_line[0]}}) {
				print $gene_data_value, " ";
			}
			for my $expression_value (@expression_line) {
				print $expression_value, " "; 
			}
			print "\n";
		} 
}




# 	1) open annotation file stream 
#	2) skip header line
# 	3) find line that matches on chromosome number
#	4) if matches on chromosome number: find line that matches on chromosome start and chromosome end
#	5) if doesn't match on chromosome number: break;
#	6) if matches on chromosome start and end: hash probe number (key) in annotation file to haplotype number in gene file (value)




