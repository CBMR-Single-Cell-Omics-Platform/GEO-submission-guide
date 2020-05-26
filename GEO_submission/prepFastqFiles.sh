#!/bin/bash

# usage: copy fastq files, gzip them individually, colled file names in text files and get md5 hashes

# Prepare files for GEO submission
GEO_DIR_TMP=/scratch/rkm916/20-schwartz-fgf1_GEOsubmission
PROJECT_ID="fgf_pilot_24" # this is not necessarily the top-level id, could be a sub-project
MKFASTQ_DIR=/nfsdata/projects-archive/dylan/tmp-marie/data-mkfastq/fgf_pilot_24 # directory where fastq files were generated
declare -a SEQ_IDS=("180606_NS500259_0259_AHMN3CBGX5" "190128_NS500259_0291_AHMJKVBGX9" "190201_NB501859_0133_AHMH7NBGX9")
declare -a FLOWCELL_IDS=("HMN3CBGX5" "HMJKVBGX9" "HMH7NBGX9")
declare -a SAMPLES_PER_SEQRUN=(2 2 2)
declare -a SAMPLE_NAMES=("1_FGF" "1_PF" "FGF_2" "PF_2" "FGF_3" "PF_3")
declare -a READTYPES=("R1" "R2" "I1")
#NCORES=10 

GEO_FASTQ_DIR=$GEO_DIR_TMP/data-fastq # where to copy fastq files to
GEO_FILEINFO_DIR=$GEO_DIR_TMP/filenames


# generate files with filenames
touch $GEO_FILEINFO_DIR/${PROJECT_ID}_fastq_filenames.txt
touch $GEO_FILEINFO_DIR/${PROJECT_ID}_fastq_hash.txt

n=0
for (( k=0; k<${#SEQ_IDS[@]}; k++)); do
	SEQ_ID=${SEQ_IDS[$k]}
	FLOWCELL_ID=${FLOWCELL_IDS[$k]}
	N_SAMPLES=${SAMPLES_PER_SEQRUN[$k]}
	
	echo $SEQ_ID 

	for (( i=0; i<${SAMPLES_PER_SEQRUN[$k]}; i++ )); do
		
		SAMPLE_NAME=${SAMPLE_NAMES[$n]}
		MKFASTQ_SAMPLE_DIR=$MKFASTQ_DIR/${SEQ_ID}/outs/fastq_path/${FLOWCELL_ID}/${SAMPLE_NAME}
		
		echo $SAMPLE_NAME

		for (( j=0; j<${#READTYPES[@]}; j++ )); do
 			ls $MKFASTQ_SAMPLE_DIR/*${READTYPES[$j]}* | cut -f 13 -d "/" | cat >> $GEO_FILEINFO_DIR/${PROJECT_ID}_fastq_filenames.txt
                        ls $MKFASTQ_SAMPLE_DIR/*${READTYPES[$j]}* | xargs md5sum | cat >> $GEO_FILEINFO_DIR/${PROJECT_ID}_fastq_hash.txt
		done

		n=$(( n+1 ))

	done
done

# copy fastq files
