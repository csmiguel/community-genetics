#paHMM-tree runs pairwise alingment and estimates distances with evol. models
#it outputs a tree.

#make directory for paHMM files
mkdir data/intermediate/paHMM-Tree
rm data/intermediate/paHMM-Tree/*

#replace "?" with "N" and run paHMM-tree
for fasta in data/intermediate/clean_fasta/*fa
do
output=$(echo $fasta | sed 's/clean_fasta/paHMM-Tree/')
cat "$fasta" | sed 's/\?/N/g' > $output
paHMM-tree --in "$output" --GTR
done
