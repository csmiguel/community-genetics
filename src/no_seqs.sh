#number of sequences per locus
for files in data/intermediate/clean_fasta/*fa
do
no=$(cat "$files" | grep '^>' | wc -l)
locus=$(echo $files | sed 's/^.*\/\(.*\).fa/\1/')
echo $locus $no
done > output/seq_locus

#number of sequences per species
cat data/intermediate/clean_fasta/*fa | grep '>' | \
sed 's/>//' | sort | uniq -c > output/seq_sp
