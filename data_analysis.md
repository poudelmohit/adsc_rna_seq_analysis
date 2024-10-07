# install sra-toolkit:

cd tools
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -vxzf sratoolkit.*.tar.gz
chmod +x sratoolkit.*/bin/*

tools/sratoolkit.*/bin/fastq-dump

## optional (add to path):

    nano ~/.bashrc
    ## Paste the following line:
        export PATH="$PATH:~/extra/adsc_rna_seq_analysis/tools/sratoolkit.*/bin"
        Cltr+O Enter Cltr+X
    source ~/.bashrc
    echo $PATH

## skipping parallel installation for NOW:

## Download SRA files:

mkdir data/raw_reads && cd $_

# here is the link to SRA Run Selector:
https://www.ncbi.nlm.nih.gov/Traces/study/?uids=32263406%2C32263405%2C32263404%2C32263402%2C32263401%2C32263400%2C32263399%2C32263398&o=acc_s%3Aa


## creating a text file of all SRR list ids:
echo "SRR28352479" >> srr_ids_list.txt
echo "SRR28352480" >> srr_ids_list.txt
echo "SRR28352481" >> srr_ids_list.txt
echo "SRR28352483" >> srr_ids_list.txt
echo "SRR28352484" >> srr_ids_list.txt
echo "SRR28352485" >> srr_ids_list.txt
echo "SRR28352486" >> srr_ids_list.txt
echo "SRR28352487" >> srr_ids_list.txt

cat srr_ids_list.txt

## downloading FASTQ files using the SRR ids:
cd data/raw_reads
cat srr_ids_list.txt | xargs -n 1 ../../tools/sratoolkit.*/bin/fastq-dump --split-files

