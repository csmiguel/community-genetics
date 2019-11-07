#paHMM-tree runs pairwise alingment and estimates distances with evol. models
#it outputs a tree.

#make directory for paHMM files
mkdir data/intermediate/paHMM-Tree
rm data/intermediate/paHMM-Tree/*

#replace "?" with "N" and run paHMM-tree
for fasta in data/intermediate/prequal/*.filtered
do
output=$(echo $fasta | sed 's/prequal/paHMM-Tree/')
cat "$fasta" | sed 's/\?/N/g' | sed 's/X/N/g' > $output
paHMM-tree --in "$output" --GTR
done
