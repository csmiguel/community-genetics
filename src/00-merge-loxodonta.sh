#!/bin/bash
#the data/raw/fasta.zip file is a renamed file from Giovanni's email on sept 20th 2019
rm -rf data/raw/fasta/*
unzip data/raw/fasta.zip -d data/raw/

#dir for elefant
mkdir data/intermediate/merge_loxodonta
#merge sequences in Loxodonta.txt to all other alleles.
#change all fasta headers to uppercase
cat data/raw/Loxodonta.txt | \
  tr '[:lower:]' '[:upper:]'  | \
  sed 's/>TRPV4_LAFRICANA_/>TRPV4_LAFRICANA/g' \
  > data/intermediate/merge_loxodonta/clean_Loxodonta.txt

#add loci in Loxodonta.txt to each file's loci
for locus in data/raw/fasta/*txt
do
  loc=$(echo $locus | sed 's/^.*\/\(.*\).txt/\1/')
  seqkit grep -r -p $loc data/intermediate/merge_loxodonta/clean_Loxodonta.txt | \
  sed 's/\(>\)/\n\1/' > temp
  cat "$locus" temp > $(echo data/intermediate/merge_loxodonta/lox$loc)
  rm temp
done
