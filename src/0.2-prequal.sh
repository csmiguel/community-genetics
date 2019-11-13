#prequal removes stretches of sequences with little homology
#it was designed initially for aa but now also supports dna
#issue: how do thresholds affect output. Does it work well on non-coding DNA?
mkdir data/intermediate/prequal
rm -rf data/intermediate/prequal/*
cp data/intermediate/clean_fasta/*fasta data/intermediate/prequal

for fasta in data/intermediate/prequal/*fasta
do
prequal "$fasta"
done
