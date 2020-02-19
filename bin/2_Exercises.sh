#!/bin/bash
# 2_Exercises.sh
# Made by Luis Rodrigo Arce Valdés, to do several population genetics tests test on wolves vcf data (19/02/2020)
# Run this script with `bash 2_Exercises.sh`
# Software used in this script: VCF-Tools

###############################IMPORTANT NOTE################################################
# This script is written asuming you have VCF-Tools installed on your local computer.
# This script was not made to run on CONABIOs cluster.
# If you need to install VCF-Tools, I personally use Conda to install bioinformatics software
# To install conda follow this instructions (try Miniconda-the light version of conda): https://conda.io/projects/conda/en/latest/user-guide/install/linux.html
# Finally run:
# 1 To add bioconda channel:
# ´conda config --add channels defaults´
# ´conda config --add channels bioconda´
# ´conda config --add channels conda-forge´
# 2 to install VCF-Tools
# ´conda install -c bioconda vcftools´
############################################################################################

#Changing directory to data
cd ../data/

# a)
echo "********************************************************************************"
echo "a) How many samples and variants (SNPs) does the file have?"
echo ""
echo "We answer this by specifing the data file"
echo ""
vcftools --vcf wolves.vcf
echo ""
echo "ANSWER:"
echo "107 samples with 13092 sites"
echo "********************************************************************************"

# b)
echo "********************************************************************************"
echo "b) Calcule the frequency for each alele for every sample in the file and save the result in another file"
echo ""
vcftools --vcf wolves.vcf --freq --out b-frequencies
echo ""
echo "ANSWER:"
head b-frequencies.frq
echo "********************************************************************************"

# c)
echo "********************************************************************************"
echo "c) How many samples does not have Missing Data?"
echo ""
vcftools --vcf wolves.vcf --max-missing 1
echo ""
echo "ANSWER:"
echo "Kept 9085 of 13092 Sites"
echo "********************************************************************************"

# d)
echo "********************************************************************************"
echo "d) Estimate the frequency of each allele for all samples, but without missing data sites, and save the results in another file"
echo ""
vcftools --vcf wolves.vcf --freq --max-missing 1 --out d-frequencies_without_MA
echo ""
echo "ANSWER:"
head d-frequencies_without_MA.frq
echo "********************************************************************************"

# e)
echo "********************************************************************************"
echo "e) How many sites have a frequency of the rare allele < 0.05?"
echo ""
vcftools --vcf wolves.vcf --max-maf 0.05
echo ""
echo "ANSWER:"
echo "Kept 5224 out of 13092 Sites"
echo "********************************************************************************"

# f)
echo "********************************************************************************"
echo "f) Estimate the heterozygosity for each sample"
echo ""
vcftools --vcf wolves.vcf --het --out f-heterozygosity
echo ""
echo "ANSWER:"
head f-heterozygosity.het
echo "********************************************************************************"

# g)
echo "********************************************************************************"
echo "g) Estimate nucleotide diversity per site"
echo ""
vcftools --vcf wolves.vcf --site-pi --out g-diversity
echo ""
echo "ANSWER:"
head g-diversity.sites.pi
echo "********************************************************************************"

# h)
echo "********************************************************************************"
echo "h) Estimate nucleotide diversity per site but only for the chromosome 3 sites"
echo ""
vcftools --vcf wolves.vcf --chr chr03 --site-pi --out h-diversity_3
echo ""
echo "ANSWER:"
head h-diversity_3.sites.pi
echo "********************************************************************************"

# i)
echo "********************************************************************************"
echo "i) Filter out sites with a frequency of the rare allele < 0.05 and generate a new file called wolves_maf05.vcf"
echo ""
vcftools --vcf wolves.vcf --max-maf 0.05 --recode --out wolves_maf05
echo ""
echo "ANSWER:"
echo "Head of the new .vcf file:"
head wolves_maf05.recode.vcf
echo "********************************************************************************"

# j)
echo "********************************************************************************"
echo "j) Covert wolves_maf05.vcf file to plink"
echo ""
vcftools --vcf wolves_maf05.recode.vcf --plink --out wolves_plink
echo ""
echo "ANSWER:"
echo "List of plink files:"
ls -lh wolves_plink*
echo "********************************************************************************"
