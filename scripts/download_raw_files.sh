#!/bin/bash
#SBATCH --job-name=sra_download         # Job name
#SBATCH --output=sra_download.out       # Standard output
#SBATCH --error=sra_download.err        # Standard error
#SBATCH --time=02:00:00                 # Time limit (adjust as needed)
#SBATCH --partition=debug              # Partition/queue name
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks=1                      # Number of tasks (one process)
#SBATCH --cpus-per-task=4               # Number of CPU cores (adjust based on resources)
#SBATCH --mem=16G                       # Memory per node (adjust based on needs)
#SBATCH --mail-type=ALL                 # Send email on start, end, fail
#SBATCH --mail-user=poudelmohit59@gmail.com  # Email for notifications

# Load necessary modules (if applicable)
# Example: module load sratoolkit

# Step 5: Download FASTQ files using fastq-dump
# Use xargs to download each SRR ID in the list
mkdir -p ../data/raw_reads && cd $_
cat ../srr_ids_list.txt | xargs -n 1 ../../tools/sratoolkit.*/bin/fastq-dump --split-files --gzip

# Check if the files were downloaded successfully
ls -lh
