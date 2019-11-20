#1. add sequences from Rattus baluensis
#see script src/locus-sp-matrix.R
#After checking missing loci with script above I selected random sequences
# from Rattus baluensis from GenBank
#These are the missing loci for R. baluensis. Some were not available in GenBank (NA),
# whereas other loci were available from 10.1111/ddi.12761
# Rattus baluensis
# 1     ABCB9 NA
# 2    APEH14 NA
# 3  CATSPER3 NA
# 4     GABRP NA
# 5       IVD NA
# 6      MMP9 MG424797
# 7   NADSYN1 NA
# 8      NPR2 MG425076
# 9      RRAS NA
# 10  TMEM87A MG425817
# 11      WLS NA


wget -q -O - 'https://www.ncbi.nlm.nih.gov/search/api/sequence/MG424797/?report=fasta' | \
sed 's/^>.*/>Rattus_baluensis/' >> data/intermediate/clean_fasta/MMP9.fa

wget -q -O - 'https://www.ncbi.nlm.nih.gov/search/api/sequence/MG425076/?report=fasta' | \
sed 's/^>.*/>Rattus_baluensis/' >> data/intermediate/clean_fasta/NPR2.fa

wget -q -O - 'https://www.ncbi.nlm.nih.gov/search/api/sequence/MG425817/?report=fasta' | \
sed 's/^>.*/>Rattus_baluensis/' >> data/intermediate/clean_fasta/TMEM87A.fa

#add sequences from Mus_spretus
#I blasted the first 70nt of each of the sequences for the missing loci (see script src/locus-sp-matrix.R for info on how to the the list of missing loci for mus spretus).
#I used the tool blastn in https://www.ensembl.org against Mus spretus SPRET_EiJ_v1
# as a reference genome. After confirming the sequence blasted against the expected
# annotated gene, I exported +- 500nt flanking nt from the target region.
# In Geneious I used the default msa algorithm to assemble the exported seq. plus
# other 2 additional sequences from us. From the alignment, I exported the target region.
# I blasted against Must spretus for all markers except for sfrs5; which was annotated
# in the M. spretus genome. I used the sequence from M. musculus GRCm38.p6 instead.

for mus in data/raw/mus/*fasta
do
  #marker name in uppercase
  b=$(echo $mus | sed 's/^.*\/\(.*\)_mus_.*$/\1/' | tr '[:lower:]' '[:upper:]')
  #replace fasta header for mus spretus and append to locus file
  cat $mus | sed 's/^>.*$/>Mus_spretus/' >> data/intermediate/clean_fasta/$b*
done


#3. fix format fasta (fix line breaks and wrap up to same line length)
for cleanfasta in data/intermediate/clean_fasta/*fa
do
  output=$(echo $cleanfasta | tr '[:upper:]' '[:lower:]' | sed 's/\.fa/\.fasta/')
  cat $cleanfasta | seqkit grep -r -p ^* > $output
  rm $cleanfasta
done
