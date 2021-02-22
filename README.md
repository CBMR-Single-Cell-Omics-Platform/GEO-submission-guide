# Tips and scripts for submitting NGS data to GEO / SRA


## Timeline
* Depositing your data on GEO is almost always a prerequisite for getting your article published, so this should be a top priority after the paper is accepted
* Allow for up to two weeks before the GEO submission is publicly available:
  * One week for collecting, preparing and transferring files
  * One week for review by GEO and to make any changes they might ask for
* See also the GEO [FAQ](https://www.ncbi.nlm.nih.gov/geo/info/faq.html#whenaccessions)


## Quick start

### 1. Create a GEO account

  * [link](https://www.ncbi.nlm.nih.gov/account/register/?back_url=/geo/submitter/) 
  (The confirmation email may get held up by the spam filter, so consider using your personal email!)
### 2. Decide what to submit to GEO and what to submit as supplementary tables
  * Read the [guidelines](https://www.ncbi.nlm.nih.gov/geo/info/seq.html)
  * Summary statistics such as differential expression should rather be submitted as supplementary tables directly to the journal  
  * [Example of a scRNA-seq experiment GEO submission](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE130710)
    * raw data: individual fastq files (.fastq.gz)
    * processed data files: 
       * filtered raw normalized count matrix in delimited format (e.g. .csv.gz)
       * normalized count matrix in delimited format (e.g. .csv.gz)
       * metadata: cell barcodes, condition, cluster assignments, and other relevant information for reproducing the analysis
  
### 3. Prepare the files for submission
  * Make sure that filenames are unique.
  * Verify that the combined file size is within 1TB. If over, [contact NCBI](geo@ncbi.nlm.nih.gov). The solution will likely be to submit _raw_ files directly to the Short Read Archive. See guidelines for SRA submissins [here](https://github.com/CBMR-Single-Cell-Omics-Platform/GEO-submission-guide/blob/master/ascp_instructions.md). 
  
  * Clone this directory 
  ``` 
  git clone https://github.com/CBMR-Single-Cell-Omics-Platform/GEO-submission-guide.git
  
  ```
  (tip: use a solid state drive to accelerate transfers and avoid problems related to network drives!). Make sure there is sufficient space to copy all project fastq files.   
  
  * Copy fastqfiles using `./scripts/cp_fastq.R` e.g.
  ```
  Rscript ./scripts/cp_fastq.R --dir_out "<path_to_copy_fastqs_to>" --mkfastq_dir "<top level fastqdir>" --seq_id_regex "<R regex for matching sequencing runs>" --sample_regex "<R regex for matching sample names>"
  ```
  (do `Rscript ./scripts/cp_fastq.R -h` for info on parameters) 
  * double-check that the right files were copied (e.g. some sequencing runs may have been discarded).
  * Download the GEO [metadata spreadsheet](https://www.ncbi.nlm.nih.gov/geo/info/examples/seq_template_v2.1.xls) template and open it
  * SERIES
    * List the authors who have specifically worked on the data being submitted, as well as the last author(s). No need to list every author.
    * Copy and paste the relevant method sections from the manuscript   
  * SAMPLES
    * Fill out most of the columns manually
    * For the 'raw file' columns, first prepare a text file (samples_table) with a single named column containing sample names, then use `prep_metadata_samples_section.R` to prepare the raw files colums:
    ```
    Rscript ./scripts/prep_metadata_samples_section.R --path_samples_table "<path_to_table_of_samples>" --path_dir_fastq "<path_to_copied_fastqs>" --path_table_out "<output_xlsx_file_path>""
    ```
    (do `Rscript ./scripts/prep_metadata_samples_section.R -h` for info on parameters) 
  * PROTOCOLS
    * Complete manually
  * DATA PROCESSING PIPELINE
    * Complete manually
  * PROCESSED DATA FILES
    * Use the `md5sum` command to generate the file checksums
  * RAW FILES
    * Get the names and md5 checksums by `cd`ing to directory or directories to which you copied the fastq files and doing:
    ```
    ls | xargs md5sum &> ../fastq_md5.txt
    ```
    * get the read lengths:
    ```
    Rscript ./scripts/get_fastq_read_lengths.R --path_dir_fastq "<path_to_copied_fastqs>" --path_file_out_readlengths "<output_delimited_file_path>"
    ```
    (do `Rscript ./scripts/get_fastq_read_lengths.R -h` for parameters) 
  * PAIRED-END EXPERIMENTS
    * delete the fields delete 'average insert size' and 'standard deviation'
    * group the fastqs in sets:
    ```
    Rscript ./scripts/prep_metadata_pairedend_section.R --path_samples_table "<path_to_table_of_samples>" --path_dir_fastq "<path_to_copied_fastqs>" --path_table_out "<output_xlsx_file_path>"
    ```
    (do `Rscript ./scripts/prep_metadata_pairedend_section.R -h` for info on parameters)  

### 4. Transfer the data
  * Follow the instructions on https://www.ncbi.nlm.nih.gov/geo/info/submissionftp.html. 
    * User a terminal multiplexer like tmux to persist the process.
  * When done, notify GEO using the [Submit to GEO web form](https://submit.ncbi.nlm.nih.gov/geo/submission/)

