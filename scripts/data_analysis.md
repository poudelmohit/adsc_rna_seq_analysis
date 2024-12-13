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

## Creating conda env
    conda create -n adsc_rna_seq -y
    conda activate adsc_rna_seq
    
## Getting required packages

    conda install sra-tools -y
    conda list
    fastq-dump --stdout -X 2 SRR390728 # just to verify installation

## Download SRA files:

    mkdir -p ../data/raw_reads && cd $_

    # here is the link to SRA Run Selector:
    https://www.ncbi.nlm.nih.gov/Traces/study/?uids=32263406%2C32263405%2C32263404%2C32263402%2C32263401%2C32263400%2C32263399%2C32263398&o=acc_s%3Aa

    # accession list of 8 samples downloaded as file accession_list.txt:
    cat accession_list.txt

## downloading FASTQ files :

    cat accession_list.txt | xargs -n1 prefetch
    
    for file in */*.sra;do
        fastq-dump --split-files --gzip $file
    done

## Quality Assessment of raw reads:

    mkdir ../initial_fastqc/
    fastqc */*.fastq.gz -threads 20 --outdir ../initial_fastqc/
    # Based on the fastqc reports, no quality control is required !!
    # There is no presence of adapter sequences as well.

## Alignment:

### Build Index:

    mkdir ../alignment && cd $_
    wget https://ftp.ensembl.org/pub/current_gtf/rattus_norvegicus/Rattus_norvegicus.mRatBN7.2.113.gtf.gz -v -nc 
    gunzip *.gz

    wget https://ftp.ensembl.org/pub/release-113/fasta/rattus_norvegicus/dna/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz -v -nc

    gunzip *.fa.gz

    mv Rattus_*.gtf rat.gtf
    mv Rattus_*.fa rat.fa

    conda install bioconda::star -y

    STAR --runThreadN 20 \
        --runMode genomeGenerate \
        --genomeDir star_index \
        --genomeFastaFiles rat.fa \
        --sjdbGTFfile rat.gtf \
        --sjdbOverhang 149


### Alignment with STAR:

    mkdir star_mapped/

    for read1 in ../raw_reads/*/*_1.fastq.gz;do
        base=$(basename $read1 "_1.fastq.gz")
        read2=$(echo $read1 | sed 's/_1/_2/')
        echo $base
        echo $read1
        echo $read2
        STAR --runThreadN 20 \
             --genomeDir star_index \
             --readFilesIn $read1 $read2 \
             --readFilesCommand zcat \
             --outFileNamePrefix star_mapped/${base}_ \
             --outSAMtype BAM SortedByCoordinate\
             --outFilterIntronMotifs RemoveNoncanonical \
             --outReadsUnmapped Fastx
    done

    ls -lh star_mapped/*.bam

    # Here, alignment failed for one sample, due to following error:
    EXITING because of FATAL ERROR in reads input: quality string length is not equal to sequence length @SRR28352479.4886151

    # Removing the empty bam file:
    ls -lh star_mapped/SRR28*79_*.bam && rm -r $_
    ls -lh star_mapped/*.bam 

## checking bam outputs:

    conda install samtools -y
    samtools quickcheck star_mapped/*.out.bam
    samtools view -H star_mapped/SRR28352484_Aligned.sortedByCoord.out.bam

## Gene Expression Quantification:

    conda install -c bioconda subread -y

    mkdir ../output/

    featureCounts -T 20 -p --countReadPairs -t exon -g transcript_id \
     --verbose -a rat.gtf -o ../output/read_counts.txt star_mapped/*.bam 
   
    ls star_mapped/*.bam





# Check genome fasta file:
grep ">" rat.fa | head

# Check chromosome names in the GTF:
cut -f1 rat.gtf | sort | uniq | head
