#!/bin/bash
# 0_Pipeline.sh
# Made by Luis Rodrigo Arce Valdés, to run all the project steps (20/02/2020)
# Run this script with `bash 0_Pipeline.sh`

echo "Downloading DATA!"
bash 1_Data_download.sh
echo "Finished downloads"
echo ""
echo "Starting the exercises from Unit 5"
echo "Each question will be separeted by a:"
echo  "********************************************************************************"
bash 2_Exercises.sh
echo "Finished exercises of VCF-Tools"
echo "Starting R analyses"
Rscript 3_Figures.R
echo "FINISHED! CHECK FIGURES AT ../"
