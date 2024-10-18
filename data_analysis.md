## Installing Conda

    mkdir tools && cd $_
    wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
    
    chmod +x Anaconda3-*.sh
    bash Anaconda3-*.sh -b -p ~/anaconda3 # running installer
    ~/anaconda3/bin/conda init # adding to PATH
    source ~/.bashrc # restarting source to apply changes
    conda --version # verifying installation


## Adding necessary channels for bioconda

    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

## Installing sra-toolkit:

    mkdir tools && cd $_
    wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
    tar -vxzf sratoolkit.current-*.tar.gz
    chmod +x sratoolkit.3.1.1-ubuntu64/bin/*
    
    sratoolkit.*/bin/fastq-dump --help

## optional (add to path):

    echo "export PATH='$PATH:~/extra/adsc_rna_seq_analysis/tools/sratoolkit.3.1.1-ubuntu64/bin'" >> ~/.bashrc
    source ~/.bashrc
    echo $PATH


## skipping parallel installation for NOW:

## Download SRA files:

    mkdir -p ../data/raw_reads && cd $_

    # here is the link to SRA Run Selector:
    https://www.ncbi.nlm.nih.gov/Traces/study/?uids=32263406%2C32263405%2C32263404%2C32263402%2C32263401%2C32263400%2C32263399%2C32263398&o=acc_s%3Aa

    

## creating a text file of all SRR list ids:
    echo "SRR28352479" >> ../srr_ids_list.txt # vivo
    echo "SRR28352480" >> ../srr_ids_list.txt # vivo
    echo "SRR28352483" >> ../srr_ids_list.txt # vitro
    echo "SRR28352484" >> ../srr_ids_list.txt # vitro
    echo "SRR28352486" >> ../srr_ids_list.txt # control
    echo "SRR28352487" >> ../srr_ids_list.txt # control

    cat ../srr_ids_list.txt

## downloading FASTQ files using the slurm script:

    sbatch ../../scripts/download_raw_files.sh
    squeue -u podelm

    scontrol show job 1344

