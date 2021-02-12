#!/tools/R/4.0.2/bin/R

library("data.table")

path_dir_fastq = "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_atac/sn_atac_fastq/"
path_file_out_readlengths = "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_atac/sn_atac_read_lengths.csv"

list_readlength <- sapply(dir(path_dir_fastq), function(filename) {
  nchar(readLines(con = gzfile(paste0(path_dir_fastq,filename)), n = 2)[2])
})

dt_out = data.table("file"=names(list_readlength), "read_length"=list_readlength)

fwrite(dt_out, path_file_out_readlengths)
