#!/bin/bash
mkdir data/intermediate/msa
rm data/intermediate/msa/*

for file in data/intermediate/prequal/*.filtered
do
output=$(echo $file | sed 's/prequal/msa/g')
cat "$file" | sed 's/X/N/g' | mafft - > $output
done
