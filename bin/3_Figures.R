#!/usr/bin/Rscript 
# 3_Figures.R
# Made by Luis Rodrigo Arce Valdés, To do a PCA test on wolves.vcf data (20/02/2020)
# Libraries used in this script: gdsfmt, SNPRelate

########################################################
# To insall gdsfmt and SNPRelate we need Bioconductor. 
# Run the following lines only the first time:
#
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(version = "3.10")
#
# Then run:
#
# BiocManager::install(c("gdsfmt","SNPRelate"))
#
# For other packages use install.packages()
########################################################

# PRE-ANALYSES REQUIREMENTS#####

# Calling up packages
library(SNPRelate)
library(ape)
library(ggplot2)


# EXPLORING OUR DATA####

# Loading data. snpgdsPED2GDS() takes PLINK PED files and transforms them to GDS format.
# If you have PLINK binary BED files you can use snpgdsBED2GDS() instead, we could transform them with PLINK.
# OR since we are laze we use snpgdsPED2GDS() instead.
# I will leave the command with its full parameters, so we can know what each one does
snpgdsPED2GDS(ped.fn = "../data/wolves_plink.ped", 
              map.fn = "../data/wolves_plink.map", 
              out.gdsfn = "../data/wolves_GDS.gds")

# Quick look for the summary of the data
snpgdsSummary("../data/wolves_GDS.gds")

# Import file to R, we will have a quick look of this file
(wolves <- snpgdsOpen("../data/wolves_GDS.gds"))

# GDS files are divided on nodes, here we can see the nodes on our files:
(nodes <- c("sample.id", "snp.id", "snp.rs.id", "snp.position", "snp.chromosome", "snp.allele", "genotype", "sample.annot"))
# The sample.annot node is subdivided in family, father, mother, sex and phenotype

# We will have a quick look at the snp.ids node, (number 2 in our nodes vector)
head(read.gdsn(index.gdsn(wolves, nodes[2])))
# And now to the samples names (number 1)
head(read.gdsn(index.gdsn(wolves, nodes[1])))

# PCA####

# You can add the "num.thread" option to change the number of cores used in the analysis
PCA <- snpgdsPCA(gdsobj = wolves)
# PCA is a list that coontains the following elements:
names(PCA)

# Estimating % of varition explained by the two first principal components
# First we multiply all the data inside the PCA$varprop vector * 100, and we round them to two decimals
pc.percent <- PCA$varprop*100
round.percent <- (round(pc.percent,2))

# The percentage of variation exmplained by the two first components is:
round.percent[1] + round.percent[2]


# Building a data.frame from the PCA results:
wolves.df <- data.frame(sample.id = PCA$sample.id,
                        EV1 = PCA$eigenvect[,1],
                        EV2 = PCA$eigenvect[,2],
                        stringsAsFactors = F)
head(wolves.df)

# Plotting & Exporting

# Creating .png file to export
png("../PCA.png", width = 1500, height = 700)

# ggplot2
ggplot(data = wolves.df) +
  geom_point(aes(x=EV2, y=EV1)) +
  ylab(paste0("Eigenvector 1 explains ", round.percent[1],"% of variation")) +
  xlab(paste0("Eigenvector 2 explains ", round.percent[2],"% of variation")) +
  labs(title = "PCA of the genetic composition of 107 wolves using 5224 SNPs", subtitle = "Build from data of Schweizer et al. 2015")
# Exporting
dev.off()

# Additional plot####

# As an additional plot we will plot the genetic diversity (pi) of all the SNPs divided by their chromosome.

# Calling the data we got with VCF-Tools
pi.df <- read.table("../data/g-diversity.sites.pi", header = T, sep = "\t")

# Plotting & Exporting

# Creating .png file to export
png("../Nucleotide_diversity.png", width = 1500, height = 734)

# ggplot2
ggplot(data=pi.df) +
  geom_boxplot(aes(x = pi.df$CHROM, y = pi.df$PI), fill = "skyblue") +
  labs(title = "Average nucleotide diversity per chromosome in 107 wolves using 5224 SNPs", 
       x = "Chromosome", 
       y = "Nucleotide diversity (Pi)",
       subtitle = "Build from data of Schweizer et al. 2015") +
  theme_minimal()

# Exporting
dev.off()