#!/tools/R/4.0.2/bin/R

#' @usage: produce a table with columns: fastqfile1, fastqfile2, fastqfile3, ..., and a row per sample

library("data.table")
library("Matrix")
library("openxlsx")
library("magrittr")
library("optparse")


option_list <- list(
  make_option("--path_samples_table", type="character",
              help = "a table with a single named column containing sample names"),
  make_option("--path_dir_fastq", type="character",
              help = "directory containing all fastq files"),
  make_option("--path_table_out", type="character",
              help = "path for output")
)

opt <- parse_args(OptionParser(option_list=option_list))
path_samples_table <- opt$path_samples_table
path_dir_fastq <- opt$path_dir_fastq
path_table_out <- opt$path_table_out

df_samples <- fread(path_samples_table) %>% setDF

list_vec_fastq = list()

for (samplename in df_samples$sample) {
  for (lane in paste0("L00", 1:4)) {
    for (id in paste0("S",1:20)) {
      vec_matches = dir(path = path_dir_fastq, pattern=paste0(samplename, "_", id ,"_", lane))

      if (length(vec_matches)>0) {
        list_vec_fastq[[paste0(samplename, "_", id, "_", lane)]] <- sort(vec_matches)
      }
    }
  }
}

message(paste0("number of fastq files: ", length(unlist(list_vec_fastq))))

mat_dummy = Matrix(data=NA,
                     nrow = length(list_vec_fastq),
                     ncol = max(sapply(list_vec_fastq,length)))

df_dummy = data.frame(as.matrix(mat_dummy))
rownames(df_dummy) = names(list_vec_fastq)

for (unique_set in names(list_vec_fastq)) {
  df_dummy[unique_set, 1:length(list_vec_fastq[[unique_set]])] <- list_vec_fastq[[unique_set]]
}

write.xlsx(df_dummy, path_table_out)
