#!/usr/bin/R

#' @usage: cp fastq files from mkfastq output directory to a single dir


suppressPackageStartupMessages(library(optparse))

option_list <- list(

  make_option("--dir_out", type="character",
              help = "output dir"),
  make_option("--mkfastq_dir", type="character",
              help = "top-level fastq directory, where the immediate subdirs are for each flowcell"),
  make_option("--seq_ids", type="character", default = NULL,
              help = "if provided, only copy fastqs from these seq ids, [default %default]"),
  make_option("--seq_id_regex", type="character", default=NULL,
              help = "if provided, and seq_ids is not, use all matching seq ids, [default %default]"),
  make_option("--sample_regex", type="character", default=NULL,
              help = "if provided, use only matching samples, [default %default]")
)


opt <- parse_args(OptionParser(option_list=option_list))

dir_out <- opt$dir_out
mkfastq_dir <- opt$mkfastq_dir
seq_ids <- opt$seq_ids
seq_id_regex <- opt$seq_id_regex
sample_regex <- opt$sample_regex

# check inputs
if (!is.null(seq_ids) & !is.null(seq_id_regex)) {
  stop("!is.null(seq_ids) & !is.null(seq_id_regex)")
}

# append / to paths if needed
if (!substr(dir_out,nchar(dir_out),nchar(dir_out))=="/") {dir_out <- paste0(dir_out, "/")}
if (!substr(mkfastq_dir,nchar(mkfastq_dir),nchar(mkfastq_dir))=="/") {mkfastq_dir <- paste0(mkfastq_dir, "/")}

# generate seq_ids if needed
if (is.null(seq_ids)) {
  seq_ids = dir(path = mkfastq_dir,  pattern = seq_id_regex, recursive = F, full.names = F)
}

# iterating over seq_ids, copy fastq files to dir_out
for (seq_id in seq_ids) {
  if (dir.exists(paste0(mkfastq_dir, seq_id))) {
    flowcell_id = substr(seq_id, nchar(seq_id)-8, nchar(seq_id))
    mkfastq_sample_dir = paste0(mkfastq_dir, seq_id, "/outs/fastq_path/", flowcell_id, "/")
    sample_dirs = dir(mkfastq_sample_dir, pattern=sample_regex, full.names = T)
    for (sample_dir in sample_dirs) {
      system2(command="cp", args = c(paste0(sample_dir,"/*"), dir_out))
    }
  }
}

