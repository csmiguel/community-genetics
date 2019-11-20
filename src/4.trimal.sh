
mkdir data/intermediate/trimal
rm -rf data/intermediate/trimal/*
cp data/intermediate/msa/* data/intermediate/trimal/

for fasta in data/intermediate/trimal/*fasta
do
divvier -partial -mincol 3 -divvygap $fasta
fasta2=$(echo $fasta | sed 's/\.fasta/ta\.partial\.fas/')
mview -in fasta $fasta2  -width 80 -html head -coloring identity -moltype dna > $fasta.html
done

rm data/intermediate/trimal/*PP
#filter out sequences which have less than seqoverlap percentage with a coveraged lower that reseoverlap.
# and remove columns with gaps in more than 0.6 of the sites.
for fasta in data/intermediate/trimal/*.fas
do
output=$(echo $fasta | sed 's/ta.parti.*$/.trimal.phy/')
trimal -in "$fasta" -out $output -htmlout $output.html -resoverlap 0.5 -seqoverlap 60 -gt 0.6 -phylip
done

#remove alignments which are very short
for phy in data/intermediate/trimal/*.phy
do
no=$(cat $phy  | head -n1 | cut -d' ' -f3)
if [ "$no" -lt 150 ]; then rm $phy; fi
done
