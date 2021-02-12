#!/tools/R/4.0.2/bin/R

#' @usage: produce a table with columns: file1, file2, file3 per demultiplexed fastq batch

library("data.table")
library("Matrix")
library("openxlsx")
library("magrittr")

path_samples_sn_rna <- "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_rna/samples_snRNA.csv"
path_samples_sn_atac <- "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_atac/samples_snATAC.csv"

path_fastq_sn_rna = "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_rna/sn_rna_fastq"
path_fastq_sn_atac = "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_atac/sn_atac_fastq"

path_xlsx_pairedend_sn_rna_out = "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_rna/pairedend_fastq_snRNA.xlsx"
path_xlsx_pairedend_sn_atac_out = "/projects/jonatan/pub-perslab/21-ludwig-dvc/sn_atac/pairedend_fastq_snATAC.xlsx"

df_samples_sn_rna <- fread(path_samples_sn_rna) %>% setDF
df_samples_sn_atac <- fread(path_samples_sn_atac) %>% setDF

df_samples_sn_rna$sample = gsub("_snRNA","",df_samples_sn_rna$sample)
df_samples_sn_atac$sample = gsub("_snATAC","",df_samples_sn_atac$sample)

#RNA
list_vec_fastq_rna = list()

for (samplename in df_samples_sn_rna$sample) {
  for (lane in paste0("L00", 1:4)) {
    for (id in paste0("S",1:15)) {
      vec_matches = dir(path = path_fastq_sn_rna, pattern=paste0("^rna_",samplename, "_", id ,"_", lane))

      if (length(vec_matches)>0) {
        list_vec_fastq_rna[[paste0("rna_",samplename, "_", id, "_", lane)]] <- sort(vec_matches)
      }
    }
  }
}

message(paste0("number of sn rna seq fastq files: ", length(unlist(list_vec_fastq_rna))))

mat_dummy_rna = Matrix(data=NA,
                           nrow = length(list_vec_fastq_rna),
                           ncol = max(sapply(list_vec_fastq_rna,length)))

df_dummy_rna = data.frame(as.matrix(mat_dummy_rna))
rownames(df_dummy_rna) = names(list_vec_fastq_rna)
colnames(df_dummy_rna) = c("I1", "R1", "R2")

for (unique_set in names(list_vec_fastq_rna)) {
  df_dummy_rna[unique_set, 1:length(list_vec_fastq_rna[[unique_set]])] <- list_vec_fastq_rna[[unique_set]]
}

#ATAC
list_vec_fastq_atac = list()

for (samplename in df_samples_sn_atac$sample) {
  for (lane in paste0("L00", 1:4)) {
    for (id in paste0("S",1:15)) {
      vec_matches = dir(path = path_fastq_sn_atac, pattern=paste0("^",samplename, "_", id ,"_", lane))

      if (length(vec_matches)>0) {
        list_vec_fastq_atac[[paste0(samplename, "_", id, "_", lane)]] <- sort(vec_matches)
      }
    }
  }
}

message(paste0("number of sn atac seq fastq files: ", length(unlist(list_vec_fastq_atac))))

mat_dummy_atac = Matrix(data=NA,
                       nrow = length(list_vec_fastq_atac),
                       ncol = max(sapply(list_vec_fastq_atac,length)))

df_dummy_atac = data.frame(as.matrix(mat_dummy_atac))
rownames(df_dummy_atac) = names(list_vec_fastq_atac)
colnames(df_dummy_atac) = c("I1", "R1", "R2", "R3")

for (unique_set in names(list_vec_fastq_atac)) {
  df_dummy_atac[unique_set, 1:length(list_vec_fastq_atac[[unique_set]])] <- list_vec_fastq_atac[[unique_set]]
}


write.xlsx(df_dummy_rna, path_xlsx_pairedend_sn_rna_out)
write.xlsx(df_dummy_atac, path_xlsx_pairedend_sn_atac_out)
# abandoned approach

# vec_S = paste0("S",1:12)
# vec_lane = paste0("00", 1:4)
# vec_reads = c("R1", "R2", "I1")


# for (read in vec_reads) {
#   for (lane in vec_lane) {
#     for (S in vec_S) {
#     df_samples_sn_rna[paste0(S, "_", lane, "_", read)] <- NA_character_
#     df_samples_sn_atac[paste0(S, "_", lane, "_", read)] <- NA_character_
#     }
#   }
# }

# # RNA
# for (samplename in df_samples_sn_rna$sample) {
#   for (S in vec_S) {
#     for (read in vec_reads) {
#       for (lane in vec_lane) {
#         samplename_truncated = gsub("_snRNA","",samplename)
#         pattern = paste0("^",samplename_truncated, ".*", S, ".*", lane, ".*", read)
#         print(pattern)
#         if (length(dir(path = path_fastq_sn_rna, pattern = pattern))>0) {
#           df_samples_sn_rna[df_samples_sn_rna$sample==samplename, paste0(S, "_", lane, "_", read)] = dir(path = path_fastq_sn_rna, pattern = pattern)
#         }
#       }
#     }
#   }
# }
#
# # ATAC
# for (samplename in df_samples_sn_atac$sample) {
#   for (S in vec_S) {
#     for (read in vec_reads) {
#       for (lane in vec_lane) {
#         samplename_truncated = gsub("_snATAC","",samplename)
#         pattern = paste0("^",samplename_truncated, ".*", S, ".*", lane, ".*", read)
#         print(pattern)
#         if (length(dir(path = path_fastq_sn_atac, pattern = pattern))>0) {
#           df_samples_sn_atac[df_samples_sn_atac$sample==samplename, paste0(S, "_", lane, "_", read)] = dir(path = path_fastq_sn_atac, pattern = pattern)
#         }
#       }
#     }
#   }
# }

