
mkdir data/intermediate/trimal
rm -rf data/intermediate/trimal/*
cp data/intermediate/msa_prequal/* data/intermediate/trimal/

for fasta in data/intermediate/trimal/*filtered
do
#output=$(echo $fasta | sed 's/msa_prequal/trimal/' | sed 's/\.fa\.filtered//')
divvier -mincol 3 -divvygap $fasta
#trimal -in "$fasta" -gt 0.8  -out $output -htmlout $output.html -resoverlap 0.3 -seqoverlap 30
mview -in fasta $fasta.divvy.fas  -width 80 -html head -coloring identity -moltype dna > $fasta.html
done


cd data/intermediate/trimal
/Applications/AMAS.py convert -d dna -u phylip -f fasta -i *.fas
cd -
