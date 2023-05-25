# Merge fastq files

## Usage
Nanopore sequencing run output consist of `fastq_pass` or `pass` folder which contains multiple files. This script merge all fastq or fastq.gz files in a given folder, and create a fastq.gz file of desinated name. The desinated filename should be give in the $FILENAME variable without suffix. For CyclomicsSeq EGA upload, please use SampleName_RunName as desinated filename.

Merge multiple fastq.gz or fastq files by:

```
bash merge_fastq_for_EGA_check_corrupt.sh <$INPATH> <$OUTPATH> <$FILENAME>
```

## fastq_corrupt_check.pl
In this repository, it also contains a perl script to check if fastq files are corrupted. This check if performed at the end of the merging. The script is called in the bash script above and do not need to be perform separately. 

### Usage: 
fastq_corrupt_check can accept any number of fastq files, and will check all files mentioned after `perl fastq_corrupt_check.pl`

```
perl fastq_corrupt_check.pl file1 file2
```

where each file has `fastq` or `fq` at the end, with no compression, `gz` compression, or `bz2` compression.

```
perl fastq_corrupt_check.pl file.fastq.bz2 file0.fq.gz file1.fastq
```


### fastq_corrupt_check.pl logic

fastq_corrupt_check checks to ensure that Fastq files are not corrupted.  
Each entry in a Fastq file has 4 lines.  The fastq file should have the following properties:

    * The 2nd line should only consist of A, C, G, T, and/or N
    * The length of the 4th line matches the length of the 2nd line
    * The 3rd line must start with a '+'
    * The file should have an integral multiple of 4 number of lines.
    
