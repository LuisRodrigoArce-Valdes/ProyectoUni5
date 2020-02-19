#!/bin/bash
# 1_Data_download.sh
# Made by Luis Rodrigo Arce Valdés, to download wolves vcf data (19/02/2020)
# Run this script with `1_Data_download.sh`
# Software used in this script: VCF-Tools & Plink

#Changing directory to data
cd ../data/

#Downloading and renaming wolves data
wget https://datadryad.org/stash/downloads/file_stream/6226
mv 6226 wolves.vcf
