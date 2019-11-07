
mkdir data/intermediate/trimal
rm -rf data/intermediate/trimal/*
cp data/intermediate/msa/* data/intermediate/trimal/

for fasta in data/intermediate/trimal/*filtered
do
divvier -partial -mincol 3 -divvygap $fasta
mview -in fasta $fasta.partial.fas  -width 80 -html head -coloring identity -moltype dna > $fasta.html
done

#remove sequences with little cov
for fasta in data/intermediate/trimal/*.fas
do
output=$(echo $fasta | sed 's/fa.filtered.partial.fas/trimal.phy/')
trimal -in "$fasta" -out $output -htmlout $output.html -resoverlap 0.35 -seqoverlap 35 -gt 0.6 -phylip
done

#remove alignments which are very short
for phy in data/intermediate/trimal/*.phy
do
no=$(cat $phy  | head -n1 | cut -d' ' -f3)
if [ "$no" -lt 150 ]; then rm $phy; fi
done
