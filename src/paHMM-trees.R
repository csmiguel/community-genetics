trees <- dir("data/intermediate/paHMM-Tree", ".tree", full.names = T)

sapply(trees, function(x) {
  locusname <- stringr::str_replace(string = x, "^.*\\/", "") %>%
    stringr::str_replace(".fa.filtered.paHMM-Tree.tree", "")
  h <- ape::read.tree(x)
  h$edge.length[is.na(h$edge.length)] <- 0.2
  pdf(file.path("output",
                paste0("paHMM-Tree_", locusname, ".pdf")
  ))
  ape::plot.phylo(h, "u", show.node.label = T, cex = 0.8,
                  main = paste0("paHMM-Tree_", locusname))
  dev.off()
})
