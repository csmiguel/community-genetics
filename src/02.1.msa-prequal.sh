#!/bin/bash
mkdir data/intermediate/msa_prequal
rm data/intermediate/msa_prequal/*

for file in data/intermediate/prequal/*.filtered
do
output=$(echo $file | sed 's/prequal/msa_prequal/g')
cat "$file" | sed 's/X/N/g' | mafft - > $output
done
