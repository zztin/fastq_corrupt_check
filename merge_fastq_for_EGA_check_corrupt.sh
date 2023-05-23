#!/bin/bash

FOLDER=$1
OUTPUT=$2
RUNNAME=$3
PERL_SCRIPT="/hpc/compgen/users/lchen/00_utils/fastq_corrupt_check/fastq_corrupt_check.pl"


# Start measuring execution time
start_time=$(date +%s)

# Check if the input folder exists
if [ ! -d "$FOLDER" ]; then
    echo "Input folder does not exist."
    exit 1
fi

# Check if the input folder only contains fastq or fastq.gz files
shopt -s nullglob
FASTQ_FILES=("$FOLDER"/*.fastq)
GZ_FILES=("$FOLDER"/*.fastq.gz)

if [ ${#FASTQ_FILES[@]} -eq 0 ] && [ ${#GZ_FILES[@]} -eq 0 ]; then
    echo "No fastq or fastq.gz files found in the input folder."
    exit 1
fi


# Concatenate fastq.gz files using cat
if [ ${#GZ_FILES[@]} -gt 0 ]; then
    cat "${GZ_FILES[@]}" > "$OUTPUT"/"$RUNNAME".fastq.gz
    perl "$PERL_SCRIPT" "$OUTPUT/$RUNNAME.fastq.gz"
    echo "Concatenated fastq.gz files into $OUTPUT/$RUNNAME.fastq.gz"
fi

# Compress and concatenate fastq files
if [ ${#FASTQ_FILES[@]} -gt 0 ]; then
    for file in "${FASTQ_FILES[@]}"; do
        gzip "$file"
        echo "Compressed $file"
        gzipped_file="$file".gz
    done
    gzipped_files=("$FOLDER"/*.fastq.gz)
    if [ ${#gzipped_files[@]} -gt 0 ]; then
        cat "${gzipped_files[@]}" >> "$OUTPUT"/"$RUNNAME".fastq.gz
        perl "$PERL_SCRIPT" "$OUTPUT/$RUNNAME.fastq.gz"
        echo "Concatenated gzipped fastq files into $OUTPUT/$RUNNAME.fastq.gz"
    fi
fi

# Done
echo "Done"

# Calculate and display execution time
end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Total execution time: $execution_time seconds"

