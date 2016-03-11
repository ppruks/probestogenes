#!/usr/bin/perl

use strict;
use warnings;

# Remove non-autosomal probes from annotation file

#my @remove_nonautosomal = ( "awk", "'$4!='X' && $4!='Y' && $4!='-''", "../../data/expression/annotation_without_autosomal.txt", $ARGV[0]);
#system(@remove_nonautosomal);

# Sort files by chromosome number, chromosome start and chrosome end 

#my @sort_annotation = ( "sort", "-n","-k4","-k5","-k6", "-o", "../../data/expression/sorted_annotation.txt", "../../data/expression/annotation_without_autosomal.txt" );
#my @sort_rohgenes = ( "sort", "-n","-k4","-k5","-k6", "-o", "../../data/expression/sorted_rohgenes.txt", $ARGV[1] );
#my @sort_expression = ( "sort", "-n", "-k4", "-k5", "-k6", "-o", "../../data/expression/sorted_expression.txt", $ARGV[2] );

#system(@sort_annotation);
#system(@sort_rohgenes);
#system(@sort_expression);

# Create empty hash for probe to haplotype matching

my %probes_to_rohgenes = ();

# Open rohgenes stream 

open my $rohgenes, "<", "../../data/expression/sorted_rohgenes_snp25_het0_len500.txt" or die $!;
#print "Opened rohgenes stream","\n";

# Skip header line 

#my @rohgenes_header = <$rohgenes>;
#shift @rohgenes_header;

# For every line in the rohgenes stream:
while( my $rohgenes_line = <$rohgenes> ) {

	print "$.", "\n";

	# Split line and store variables
	my @rohgenes_line = split /\s+/, $rohgenes_line;
	my $rohgenes_line_ref = \@rohgenes_line;
	#print "Split rohgen line","\n";

	# Open annotation file stream
	open my $annotation, "<", "../../data/expression/sorted_annotation.txt" or die $!;
	my $first_line = <$annotation>;
	#print "Opened annotation stream","\n";

	# Skip header line
	#my @annotation_header = <$annotation>;
	#shift @annotation_header;


	# Fill up probe to haplotype hash  
	while( my $annotation_line = <$annotation> ) {

		#print "$.","\n";

		# Skip header line 
		next if $. < 2;

		# Split line, store line in an array, get reference to array
		my @annotation_line = split /\s+/, $annotation_line;
		#print "Split annotation line", "\n";
		#print "Rohgenesline: ", $rohgenes_line[3], $rohgenes_line[4], $rohgenes_line[5], "\n";
		#print "Annotationline: ", $annotation_line[3], $annotation_line[4], $annotation_line[5], "\n";
		#print "Subtract: ", ($annotation_line[4] - $rohgenes_line[4]), "\n";
		
		# Keep looking if annotation chromosome number is less or equal to roh chromosome number
		#print "Annotation chromosome is ", $annotation_line[3], " Rohgenes chromosome is ", $rohgenes_line[3], "\n";
		#if( $annotation_line[3] <= $rohgenes_line[3] ) {
			#print "Entered first if statement", "\n";
			# If roh file's chromosome number, start and end match those of annotation file's, then add (probenumber : rohgenes_data_ref) key:value pair to hash
			
			if ( ($rohgenes_line[3] == $annotation_line[3]) && ($rohgenes_line[4] == $annotation_line[4]) && ($rohgenes_line[5] == $rohgenes_line[5]) ) {
				print $rohgenes_line,"\n";
				%probes_to_rohgenes = {
					$annotation_line[1] => $rohgenes_line_ref # map probe number to reference to rohgenes_line
				};
			}
		#} else {
			#print "No match.","\n";
			#last;
		#}
	}
}

my $hash_size = keys %probes_to_rohgenes; 
print "Hash size is: ", $hash_size, "\n"; 

# Open expression file stream 

open my $expression, "<", "../../data/expression/ExpressionData.txt.QuantileNormalized.Log2Transformed.ProbesCentered.SamplesZTransformed.CovariatesRemoved.txt" or die $!;
#print "Opened expression stream","\n";
# Skip header line

#my @expression_header = <$expression>;
#shift @expression_header;

# Loop over lines of expression file and use probe number to index into probes_to_rohgenes hash and print out gene data to STDOUT

while( my $expression_line = <$expression> ) {

	# Skip header line
	next if $. < 2;

	# Split line and store it in an array
	my ($probenumber) = split /\s+/, $expression_line;
	#print "Split expression line. Probenumber is ", $probenumber ,"\n";

	# Check if the hash contains the key probenumber, if yes, then index into hash, dereference and print elements of array 
	if( exists $probes_to_rohgenes{$probenumber} ) {
			#print "Probenumber exists in hash keys.", "\n";
			for my $gene_data_value (@{$probes_to_rohgenes{$probenumber}}) {
				print $gene_data_value, " ";
			}
			print $expression_line, "\n";
		} 
}




# 	1) open annotation file stream 
#	2) skip header line
# 	3) find line that matches on chromosome number
#	4) if matches on chromosome number: find line that matches on chromosome start and chromosome end
#	5) if doesn't match on chromosome number: break;
#	6) if matches on chromosome start and end: hash probe number (key) in annotation file to haplotype number in gene file (value)




