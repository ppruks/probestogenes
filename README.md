# ROHExp analysis plan 

## Call ROHs
	1) sort .map and .ped according to physical position (plink --file data --recode)

	.map file format (NO header):

	Each line of the MAP file describes a single marker and must contain exactly 4 columns:

	CHR      Chromosome (1-22, X, Y or 0 if unplaced)
	SNP 	 Single Nucleotide Polymorphism (rs# or snp identifier)
	DISTANCE Genetic distance (morgans)
	POSITION Base-pair position (bp units)


	.ped file format (NO header):

	The PED file is a white-space (space or tab) delimited file: the first six columns are mandatory:
     Family ID
     Individual ID
     Paternal ID
     Maternal ID
     Sex (1=male; 2=female; other=unknown)
     Phenotype 

	2) call ROHs using ROH1.1:


		Installation: 

			- ROH program can be downloaded from http://bioinfo.ut.ee/ROH/  
			- Copy roh.zip file into your computer, unzip the file: 
			- unzip roh.zip 
			- To compile the program, cd into the folder where files have been unpacked and type: make

		Command line options: 

	ROH 	--file {fileroot}	      		  Specify .ped and .map files. NB! Files must be sorted according to physical position. 
									  		  This can be done with PLINK: (plink --file data --recode). 

			--homozyg                 		  Calculates IBS homozygous areas and which generates *.roh file 

			--cutoff-p {0.000001}     		  Specify p-value for cutoff 

			--homozyg-het                     Specify the number of heterozygous genotypes allowed            

 			--hfile {filename}                Read precalculated homozy-zous area's file (*.roh)

 			--homozyg-group                   Create file with info about overlapping homozygous areas  

 			--homozyg-group-cutoff {0.05}     Specify the minimum frequency of overlapping areas       

			--cnv {filename}     			  Specify the file name   for CNV files for excluding over-lapping homozygous areas

 			--homozyg-assoc           		  Creates "dummy" files for association analysis (.map and .ped)


	4) ROH1.1 generates a *.roh file in the same directory that contains the *.map and *.ped files
	5) *.roh output:

	ROH file format:
     FID     Family ID
     IID     Individual ID
     CHR     Chromosome
     SNP1    Start marker
     SNP2    End marker
     BP1     Start position (base-pair)
     BP2     End position (base-pair)
     LENGTH  Size in BP
     SIZE    Size in markers
     SIZE_LEN SIZE/LENGTH
     HET     Proportion of heterozyge markers (if allowed)
     HOM     Proportion of Homozygote markers
     P       P-value calculated according to marker frequencies


## Call commonROHs
	1) use ROH1.1 (ROH --file data --hfile *.roh --homozyg-group)
	2) ROH1.1 generates a *.common.roh file in the same directory that contains the *.roh file
	3) *.common.roh output:

	COMMON ROH file format:
     CHR     Chromosome
     BP1     Start position (base-pair)
     BP2     End position (base-pair)
     SNP1    Start marker
     SNP2    End marker
     SIZE    Size in markers
     LENGTH  Size in BP
     FREQ    Frequency in population
     ALLELES Marker alleles in homozygous haplotype

## Filter commonROHs
	1) set parameters for number of SNPs and length of a commonROH in bps 

## Find genes in commonROHs based on annotation file 
	1) sort ANNOTATION FILE and COMMON ROH file according to CHR, BP1 (CHRSTART) and BP2 (CHREND)
	2) get all genes in the annotation file within +- (specify) kb of every commonROH 

	ANNOTATION FILE format (contains header line):

	PLATFORM				Gene expression platform (e.g. HT12v3)
	HT12v3-ARRAYADDRESS		Probe ID (e.g. 6100709)
	SYMBOL					Gene name (e.g. TTF2)
	CHR 					Chromosome 
	CHRSTART				Start (base-pair)
	CHREND					End (base-pair)
	PROBE 					Probe index
	SEQ						Probe sequence (e.g. AGCCGCGACCTGAAGCAGCACATCGCCTCACGCTCGAGTATAACTTCCAC)

	2) match every gene with a commonROH ID (from 1 to however many commonROHs are left after filtering)
	3) create a hash with Probe IDs as keys and an array of commonROH ID, platform, ..., probe, seq as value 

## Associate genes with expression data
	
	EXPRESSION FILE format (contains header line with sample IDs e.g. 81907):

	HT12v3-ARRAYADDRESS 	Probe ID (e.g 6100709)
	SAMPLE IDs 				e.g. 81907 (in this case we have 1104 individuals)

	1) use Probe IDs to index into hash and print out commonROH ID, platform, ..., probe, seq, sample ids ... and print out data
	2) match every commonROH ID with every expression sample and print out data 

## Run ANOVA for all commonROHs and plot boxplots of expression vs. commonROHs
	1) read commonROH ID:expression sample data into R
	2) run ANOVA 
	3) filter commonROHs based p-value cut-off (10^-6) and print out data
	4) plot boxplots (expression vs. commonROH IDs)

## Run ANOVA for every gene in commonROH with p-value below cut-off and plot boxplots