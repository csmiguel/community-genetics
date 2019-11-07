#plot tree
#usage eg: Rscript src/functions/plot-tree.R data/intermediate/astral-paHMMtree/output paHMMtree.pdf
args <- commandArgs(trailingOnly = TRUE)
tr <- ape::read.tree(args[1])
tr <- ape::root(tr, "Mus_spretus")
tr$edge.length[is.na(tr$edge.length)] <- 0.2
pdf(file.path("output", args[2]))
plot(tr, cex = .4,
     show.node.label = T)
dev.off()
