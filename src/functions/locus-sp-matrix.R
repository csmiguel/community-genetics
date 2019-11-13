library(dplyr)

data <-
  seq_along(dir("data/intermediate/clean_fasta", full.names = T)) %>%
  lapply(function(x){
    h <- seqinr::read.fasta(dir("data/intermediate/clean_fasta", full.names = T)[x])
    data.frame(sp = names(h),
               locus = dir("data/intermediate/clean_fasta")[x] %>%
                 stringr::str_replace(".fa", ""))
  }) %>% rbind_list()
data$value = 1

locusmatrix <- reshape::cast(data, sp ~ locus, fill=FALSE)

sel <- filter(locusmatrix, sp == "Rattus_baluensis")[, ] %>%
  {as.numeric(.) == 0}
names(locusmatrix)[sel][-1]

sel <- filter(locusmatrix, sp == "Mus_spretus")[, ] %>%
  {as.numeric(.) == 0}
names(locusmatrix)[sel][-1]
