#!/bin/bash
#the data/raw/fasta.zip file is a renamed file from Giovanni's email on sept 20th 2019
unzip data/raw/fasta.zip -d data/raw/

#make directories for intermediate files
mkdir data/intermediate/clean_fasta

# STEPS:
# 1. remove  WINDOW's line break
# 2. remove trailing and leading ?'s
# 3. remove line breaks
# 4. remove lines with empty ">"
# (4.1 fix fasta header of IL34-0008358 , Irf5-0018961, Klc2-0046729)
# 5. wrap lines to 80 characters
# 6. saves output to data/intermediate/clean_fasta

find data/raw/fasta -name *txt | while read file
do
output=$(echo $file | sed 's/raw\/fasta\/\(.*\).txt/intermediate\/clean_fasta\/\1.fa/')
cat "$file" | sed -e 's/\r$//;s/^?\+//g;s/?\+$//g' | \
   awk 'NF > 0 {blank=0} NF == 0 {blank++} blank < 1'| \
   sed ':a;N;$!ba;s/\n>\n/\n/g' | \
   sed -e 's/IL34-0008358/>IL34-0008358/;s/Irf5-0018961/>Irf5-0018961/;s/Klc2-0046729/>Klc2-0046729/' |\
   gawk -f src/functions/wrap-fasta-sequence.awk - > $output
done
