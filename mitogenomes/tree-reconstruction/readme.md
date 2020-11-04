# Phylogenetic analysis of mitochondrial genomes
The names of the fasta mitogenomes that Giovanni sent me on April 2020 to match the following nomenclature: ">genus_species_code". Then I, added *R. baluensis*

To clean the intermediate files generated from previous analysis run:
```
rm *mafft* partitions.txt 
rm -rf raxml/
rm -rf cytb/
rm -rf pos3/
```

## 1. Annotate mitogenomes using the *annotate* module from mitoZ{doi:10.1093/nar/gkz173}
```
seqkit seq -ni mitogenomes.fasta | while read sample
do
cat mitogenomes.fasta | seqkit grep -r -p "$sample" > temp.fasta
docker run -v $PWD:/project  --rm guanliangmeng/mitoz:2.4-alpha \
  python3 /app/release_MitoZ_v2.4-alpha/MitoZ.py annotate \
  --genetic_code 2 --clade Chordata \
  --outprefix "$sample" --thread_number 2 \
  --fastafile temp.fasta
done
rm temp.fasta
```
For some reason the script failed only with sample EBD2011057001 and I had to run by hand the script `docker run -v $PWD:/project  --rm guanliangmeng/mitoz:2.4-alpha  python3 /app/release_MitoZ_v2.4-alpha/bin/common/gbseqextractor_v2.py -f EBD2011057001_mitoscaf.fa.gbf -prefix EBD2011057001 -types CDS rRNA tRNA wholeseq misc_feature -p -l -rv`

This step has been the most difficult to automatize.
## 2. split sequence by feature

MitoZ already splits fasta by annotated genes, so this step can be skipped.

Check all mitogenomes have the 37 genes annotated (sample closest.species number.of.genes):

```
for summary in *result
do
sp=$(cat $summary/summary.txt | grep '#Seq_id' -A 1 | head -n2 | tail -n1 | sed 's/ .*.yes.//')
gen=$(cat $summary/summary.txt | grep '^Genes totally found')
echo $sp $gen
done
```

## 3. per-gene multiple sequence alignments

Create multifasta with all sequences per gene:

```
rm concatenated_pergene.fasta

for sample in *result
do
cat "$sample"/*cds "$sample"/*rrna "$sample"/*trna >> concatenated_pergene.fasta
done
```

Optional step to keep specific taxa. I do this to match the taxa in the mtDNA tree with those used for the nuclear tree.
```
cat concatenated_pergene.fasta | seqkit grep -r \
-p BOR531 \
-p BOR036 \
-p EBD2012064590 \
-p EBD2012-064-084 \
-p EBD2012-064-125 \
-p BOR352 \
-p BOR002 \
-p BOR003 \
-p BOR042 \
-p BOR567 > filtered
mv filtered concatenated_pergene.fasta
```

The header of the fasta files follows this structure `BOR567;COX3;len=785;[8590:9374](+)`.
The genes on the light strand (-) are reverse-complemented automatically by MitoZ.

Per gene multiple sequence alignments. I added ";" to the matching pattern to differentiate between ND4 and ND4L
```
rm *mafft* *trimal* *html
seqkit seq -ni concatenated_pergene.fasta | cut -d';' -f2 | \
sed -e 's|trn..||;s|)||' | sort | uniq | sed 's/ND4$/ND4;/' | while read gene
do
cat concatenated_pergene.fasta | \
seqkit grep -r -p $gene | \
mafft - > "$gene"_mafft.fasta
done

mv  *";"* ND4_mafft.fasta
```

## 4. trim MSA

For coding DNA the alignment split by codon position and the Gblocks:
```
#gblocks for noncoding
for noncoding in [a-z]*mafft.fasta
do
/Applications/Gblocks $noncoding -t=d -e=-gb1 -b4=2 -b1=20 -d=n
done

#coding dnaa
#gblocks
for coding in [A-Z]*mafft.fasta
do
/Applications/Gblocks $coding -t=c -e=-gb1 -b1=20 -b4=2 -d=n
done

#split by codon
for coding in [A-Z]*gb1
do
rm summary.txt partition.txt
#get msa length
/Applications/AMAS.py summary -d dna -i $coding -f fasta
lenal=$(cat summary.txt | tail -n1 | awk '{print $3}')
#build partition file
echo -e "pos1 = 1-xxx\3\npos2 = 2-xxx\3\npos3 = 3-xxx\3" | sed "s/xxx/$lenal/" > partition.txt
#split
/Applications/AMAS.py split -d dna -i $coding -f fasta -u fasta -l partition.txt
done

rm summary.txt partition.txt
```
I translated to proteins the output from Gblocks to check the reading frame of the protein-coding genes is kept: https://www.ebi.ac.uk/Tools/st/emboss_transeq/

## 5. Clean headers

Clean names from fasta headers. Only leave sample name (e.g. >BOR531):
```
#for non-coding msa
for fasta in [a-z]*gb1
do
outname=$(echo $fasta | sed 's/gb1/gb12/')
cat $fasta | sed 's/;.*$//' > $outname
done

#for coding msa
for fasta in [A-Z]*out.fas
do
outname=$(echo $fasta | sed 's/fas/gb12/')
cat $fasta | sed 's/;.*$//' > $outname
done
```
## 6. Prepare input for PartitionFinder

Concatenate MSA and move files to the PartitionFinder directory:
```
/Applications/AMAS.py concat -i *gb12 -d dna -f fasta -u phylip
mv concatenated.out partitionfinder/concatenated.out
cat partitions.txt | sed 's/_mafft//;s/-out//' > partitionfinder/partitions.txt
rm partitions.txt
```
Prepare by hand `partitionfinder/partition_finder.cfg`. Paste the partitions from partitions.txt.

## 7. Determine best partition scheme

I used PartitionFinder2.1.1. Since it requires python 2.7 to run, I run it in a conda environment: `source activate py27`. I only focused on the partition scheme and not on the different models since raxml only allows GTRGAMMA anyways.

Then run the command:
```
python /Applications/partitionfinder-2.1.1/PartitionFinder.py partitionfinder --raxml
```
## 8. mitotrees  with RAxML

Create partition file:
```
mkdir raxml
cat partitionfinder/analysis/best_scheme.txt | grep ^DNA > raxml/partitions_raxml
```
Run RAxML
```
p=$(pwd)
raxml -f a -m GTRGAMMA -p 12345 -x 12345 -# autoMRE -s partitionfinder/concatenated.out -n mitogenomes -T2 -w $p/raxml -q raxml/partitions_raxml
```

## 9. cytb trees

Prepare directory and files:
```
mkdir cytb

cp CYTB_*gb12 cytb

mkdir cytb/partitionfinder
cp partitionfinder/partition_finder.cfg cytb/partitionfinder

cd cytb
/Applications/AMAS.py concat -i CYTB_*gb12 -d dna -f fasta -u phylip -p partitions_cytb -t concatenated.out
cd ../
```
Run partitionfinder:
#Edit by hand config file!!!
```
source activate py27
cp cytb/concatenated.out cytb/partitionfinder/concatenated.out
python /Applications/partitionfinder-2.1.1/PartitionFinder.py cytb/partitionfinder --raxml
```
Prepeare files for RAxML:
```
mkdir cytb/raxml
cat cytb/partitionfinder/analysis/best_scheme.txt | grep ^DNA > cytb/raxml/partitions_raxml
```
Run RAxML
```
p=$(pwd)
raxml -f a -m GTRGAMMA -p 12345 -x 12345 -# autoMRE -s cytb/partitionfinder/concatenated.out -n cytb -T2 -w $p/cytb/raxml -q cytb/raxml/partitions_raxml
```