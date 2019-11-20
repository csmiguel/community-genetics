#!/bin/bash
mkdir data/intermediate/msa
rm data/intermediate/msa/*

for file in data/intermediate/clean_fasta/*fasta
do
output=$(echo $file | sed 's/clean_fasta/msa/g')
cat "$file" | mafft - > $output
done
