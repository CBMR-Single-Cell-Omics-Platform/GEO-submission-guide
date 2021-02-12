#' @usage: produce a table with columns: sample names, and a column for each corresponding fastq, so each sample is one row

library("data.table")
library("Matrix")
library("openxlsx")
library("magrittr")
library("optparse")

# params

option_list <- list(
  make_option("--path_samples_table", type="character",
              help = "a table with a single named column containing sample names"),
  make_option("--path_dir_fastq", type="character",
              help = "directory containing all fastq files"),
  make_option("--path_table_out", type="character",
              help = "path for output"),
)

opt <- parse_args(OptionParser(option_list=option_list))
path_samples_table <- opt$path_samples_table
path_dir_fastq <- opt$path_dir_fastq
path_table_out <- opt$path_table_out


# run script

df_samples <- fread(path_samples_table) %>% setDF

#RNA
list_vec_fastq = lapply(df_samples[[1]], function(samplename){
  dir(path = path_dir_fastq, pattern=samplename)
})

names(list_vec_fastq) <- df_samples[[1]]

message(paste0("number of fastq files attributed to samples: ", length(unlist(list_vec_fastq))))

mat_dummy = Matrix(data=NA,
                     nrow = nrow(df_samples),
                     ncol = max(sapply(list_vec_fastq,length)))

df_dummy = data.frame(as.matrix(mat_dummy))
rownames(df_dummy) = df_samples[[1]]

for (samplename in df_samples[[1]]) {
  df_dummy[samplename, 1:length(list_vec_fastq[[samplename]])] <- list_vec_fastq[[samplename]]
}

write.xlsx(df_dummy, path_table_out)
