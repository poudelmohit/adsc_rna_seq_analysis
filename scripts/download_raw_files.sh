#!/bin/bash
#SBATCH --job-name=fastq-dump-job       # Job name
#SBATCH --output=fastq-dump-%j.out      # Output file (%j will be replaced by job ID)
#SBATCH --error=fastq-dump-%j.err       # Error file (%j will be replaced by job ID)
#SBATCH --time=2:00:00                 # Time limit (HH:MM:SS)
#SBATCH --cpus-per-task=10               # Number of CPU cores per task
#SBATCH --mem=16G                       # Memory limit
#SBATCH --mail-type=END,FAIL            # Notifications for job done or fail
#SBATCH --mail-user=poudelmohit59@gmail.com   # Email for notifications
#SBATCH --partition=debug             # Partition (queue) to submit to

# Source bashrc to ensure PATH is correctly set
source ~/.bashrc                # Example: Load SRA Toolkit if it's available on your HPC

echo "starting job.."
echo $pwd

# fastq-dump command
cat ../srr_ids_list.txt | xargs -n 1 ~/extra/adsc_rna_seq_analysis/tools/sratoolkit.3.1.1-ubuntu64/bin/fastq-dump --split-files --gzip --skip-technical

echo "done"

