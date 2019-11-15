library(dplyr)
library(ggplot2)

system("mkdir data/intermediate/temp; cp data/intermediate/trimal/*phy data/intermediate/temp")
system("for phy in data/intermediate/temp/*phy; do output=$(echo $phy | sed 's/trimal.phy/fasta/'); readal -in $phy -fasta -out $output; done")

prop <- {
  loci <<- dir("data/intermediate/temp",
     pattern = ".fasta", full.names = T)
     } %>% #list files
  lapply(function(x){
  seqinr::read.fasta(x) %>% #read fasta
  lapply(function(y){
    no_NA <- stringr::str_count(y, "c|g|t|a") %>% sum() #numober of c|g|t|a
    l <- length(y) #length of alignment
    prop_no_NA <- no_NA / l #proportion of c|g|t|a to total length
  })
  })
names(prop) <-
  stringr::str_replace(loci, "data/intermediate/temp/(.*).fasta", "\\1")
plot_data <-
  reshape::melt(prop) %>%
  setNames(c("Prop", "Species", "Locus")) %>%
  as_tibble() %>%
  dplyr::mutate(Species = stringr::str_replace(Species, "_", " ")) %>%
    dplyr::mutate(Species = as.factor(Species)) %>%
    dplyr::mutate(Locus = as.factor(Locus)) %>%
  dplyr::mutate(Species = factor(
    Species, levels(Species)[c(5, 4, 3, 1, 2, 6, 10, 7, 9, 8)]))

ggplot(plot_data) +
  geom_point(aes(x = Locus, y = Species, color = Prop), size = 5, shape = 15) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 90),
    axis.text.y = element_text(face = "italic")
    ) +
  scale_color_gradient(low = "white", high = "black")
ggsave("output/missing_plot.pdf", height = 3, width = 7)

system("rm -rf data/intermediate/temp")
