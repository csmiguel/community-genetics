src/0.1-clean_fasta.sh
src/0.2-prequal.sh


#mode 1: msa + raxml
src/1.1.msa.sh
src/1.2.trimal.sh
src/1.3.raxml.sh
src/1.4.astral-raxml.sh

#mode 2: paHMM-Tree
src/2.1.paHMM-Tree.sh
src/2.2.astral-paHMM-tree.sh

#plot trees
#raxml
Rscript src/raxml-trees.R
Rscript src/functions/plot-tree.R data/intermediate/astral/output astral.pdf
#paHMM
Rscript src/paHMM-trees.R
Rscript src/functions/plot-tree.R data/intermediate/astral-paHMMtree/output astral-paHMMtree.pdf

#compute no locia and species
src/no_seqs.sh
