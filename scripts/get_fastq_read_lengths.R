#!/tools/R/4.0.2/bin/R

library("data.table")
library("optparse")

option_list <- list(
  make_option("--path_dir_fastq", type="character",
              help = "directory containing all fastq files"),
  make_option("--path_file_out_readlengths", type="character",
              help = "path for output"),
)

opt <- parse_args(OptionParser(option_list=option_list))
path_dir_fastq <- opt$path_dir_fastq
path_table_out <- opt$path_table_out

list_readlength <- sapply(dir(path_dir_fastq), function(filename) {
  nchar(readLines(con = gzfile(paste0(path_dir_fastq,filename)), n = 2)[2])
})

dt_out = data.table("file"=names(list_readlength), "read_length"=list_readlength)

fwrite(dt_out, path_file_out_readlengths)
