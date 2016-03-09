#!/usr/bin/perl

# Make Rule 1 - references to variables with names

#$aref = \@array; # $aref now holds a reference to @array
#$href = \%hash; # $href now holds a reference to %hash
#$sref = \$scalar # $sref now holds a reference to $scalar

#$xy = $aref; # $xy now hold a reference to @array
#$p[3] = $href # $p[3] now holds a reference to %hash
#$z = $p[3]; # $z now holds a reference to %hash

# Make Rule 2

$aref = [ 1, "foo", undef, 13 ];
# $aref now holds a reference to an array

$href = { APR => 4, AUG=> 8};
# $href now holds a reference to a hash

# This:
$aref = [ 1, 2, 3 ];

# Does the same as this:
#@array = (1, 2, 3);
#$aref = \@array;

# Use Rule 1

# These are exactly the same
$h{'blue'} = 17;
$href = \%h;
${$href}{'red'} = 15;

# Check
print $href, "\n";
print $h{'blue'},"\n";
print $h{'red'},"\n";

# Looping over an array using a reference

# Make array 
@colors = ("blue", "black", "green");

# Turn array into reference

$colors_ref = \@colors;

# Loop over colors array and print out elements

for my $color (@{$colors_ref}) {
	print $color,"\n";
}

# Or alternatively make an array without a name

$aref = ["yellow","cyan","maroon"];

for my $color (@{$aref}) {
	print $color, "\n";
}

# Make a hash

# Array containing chromosome num, chromosome start, chromosome end
$probe = '643567';
@gene_data = ("1","300000","400000");
$gene_data_ref = \@gene_data;

%probes_to_genes = (
	$probe => $gene_data_ref
	);

# Index into probes_to_genes hash and print out gene data

for my $field (@{$probes_to_genes{'643567'}}) {
	print $field, " ";
}
print "\n";














