#!/bin/bash
mkdir data/intermediate/msa

find data/intermediate/clean_fasta/*fa | while read file
do
output=$(echo $file | sed 's/clean_fasta/msa/g')
mafft "$file" > $output
done


#convert msa from fasta -> phylip
cd data/intermediate/msa
/Applications/AMAS.py convert -d dna -u phylip -f fasta -i *.fa
cd -
