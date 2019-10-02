#plot tree
#usage eg: Rscript src/05-plot-tree.R data/intermediate/astral-paHMMtree/output
args = commandArgs(trailingOnly=TRUE)
args[1]
tr <- ape::read.tree(args[1])
tr <- ape::root(tr, "Loxodonta_africana")
pdf("output/introns_species_tree.pdf")
plot(tr, cex = .4)
dev.off()
