# Guide to GEO submission
@author Jonatan Thompson, Tune Pers lab, rkm916 at ku dot dk
@date 20200320

## General timeline
* [FAQ](https://www.ncbi.nlm.nih.gov/geo/info/faq.html#whenaccessions)
* Depositing your data on GEO is a prerequisite for getting your article published
* You should allow for up to two weeks before the GEO submission is publically available:
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
  
  * Clone this directory (tip: use a solid state drive to accelerate transfers and avoid problems related to network drives!). Make sure there is sufficient space to copy all project fastq files.
  * Edit the variables at the top of `prepFastqFiles.sh` and run it `bash prepFastqFiles.sh` to copy the fastq files and generate lists of filenames and md5 checksums for the metadata spreadsheet. If there is more than one subproject, make a separate copy of `prepFastqFiles.sh` for each.
  
* Download and complete the GEO [metadata spreadsheet](https://www.ncbi.nlm.nih.gov/geo/info/examples/seq_template_v2.1.xls) template
      * Series
        * List the authors who have specifically worked on the data being submitted, as well as the last author(s). No need to list every author.
        * Copy and paste the relevant method sections from the manuscript   
      * Samples
        * Insert a column for *each raw file*, e.g. for each .fastq file. Copy and paste the lists of filenames generated above.
      * Raw files
        * Insert a row for *each raw file*, e.g. for each .fastq file. Copy and paste the lists of filenames generated above.
      * file checksum
        * Fill out using the list of checksums generated above
### Upload materials
  * Follow the instructions on https://www.ncbi.nlm.nih.gov/geo/info/submissionftp.html. 
  * avoid sftp as it is very slow
  * Make sure to use tmux or similar to persist the process as it can take days! 
  * When done 
      * notify GEO using the [Submit to GEO web form](https://submit.ncbi.nlm.nih.gov/geo/submission/)
      * delete the copies of the fastq files and move the bash scripts to the permanent project folder for future reference

