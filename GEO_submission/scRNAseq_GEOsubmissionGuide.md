# Guide to GEO submission
@author Jonatan Thompson, Tune Pers lab, rkm916 at ku dot dk
@date 20190716

## General timeline
* [FAQ](https://www.ncbi.nlm.nih.gov/geo/info/faq.html#whenaccessions)
* Depositing your data on GEO is a prerequisite for getting your article published
* You should allow for *at least* two weeks before the GEO submission is publically available:
  * One week for collecting information, preparing and submitting files
  * One week for review of your GEO submission and making changes if necessary

## Step-by-step guide 
### Create a GEO account
  * [link](https://www.ncbi.nlm.nih.gov/account/register/?back_url=/geo/submitter/) 
  * The confirmation email may get held up by the KU spam filter 
### Decide what to submit to GEO and what to submit as supplementary tables
  * Read the [guidelines](https://www.ncbi.nlm.nih.gov/geo/info/seq.html)
  * Summary statistics such as differential expression should rather be submitted as supplementary tables directly to the journal  
  * [Example of a scRNA-seq experiment GEO submission](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE130710)
    * raw data: individual fastq files 
    * processed data files: 
       * normalized expression matrix in .csv format
       * metadata: cell barcodes, condition, cluster assignments, and other relevant information for reproducing the analysis
### Prepare the files for submission
  1. Compress files individually using gzip (`gzip <myfile>`). Do *not* combine files in tarballs.
  2. Make a new directory with subdirectories for raw and processed files and copy files to it (tip: use a solid state drive to accellerate transfers)
  3. Generate a text file with filenames followed by the md5sum hash of each file. Combine the md5sums into one or two files. E.g. `for filename in $GEO_DIR/perslab/fastqfiles/*.fastq.gz; do md5sum $filename; done > md5sums.txt`   
  4. Download and complete the [metadata spreadsheet](https://www.ncbi.nlm.nih.gov/geo/info/examples/seq_template_v2.1.xls) template
    * Series
      * List the authors who have specifically worked on the data being submitted, as well as the last author(s). No need to list every author.
      * Copy and paste the relevant method sections from the manuscript
    * Samples
      * Insert a column for *each raw file*, e.g. for each .fastq file 
    * Raw files
      * Insert a row for *each raw file*, e.g. for each .fastq file
### Upload materials
  * Follow the instructions on https://www.ncbi.nlm.nih.gov/geo/info/submissionftp.html
  * Make sure to use tmux or similar to persist the process as it can take days
  * Notify GEO using the [Submit to GEO web form](https://submit.ncbi.nlm.nih.gov/geo/submission/)

