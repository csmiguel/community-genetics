trees <- dir("data/intermediate/raxml", "RAxML_bipartitions\\.", full.names = T)

sapply(trees, function(x) {
  locusname <- stringr::str_replace(string = x, "^.*\\.", "")
  h <- ape::read.tree(x)
  h$edge.length[is.na(h$edge.length)] <- 0.2
  pdf(file.path("output",
                paste0("raxml_", locusname, ".pdf")
                ))
  ape::plot.phylo(h, "u", show.node.label = T, cex = 0.8,
                  main = paste0("raxml", locusname))
  dev.off()
})
