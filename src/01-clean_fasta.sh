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
# (4.2 fix taxa names)
# 5. wrap lines to 80 characters
# 6. saves output to data/intermediate/clean_fasta

find data/raw/fasta -name *txt | while read file
do
output=$(echo $file | sed 's/raw\/fasta\/\(.*\).txt/intermediate\/clean_fasta\/\1.fa/')
cat "$file" | sed -e 's/\r$//;s/^?\+//g;s/?\+$//g' | \
   awk 'NF > 0 {blank=0} NF == 0 {blank++} blank < 1'| \
   sed ':a;N;$!ba;s/\n>\n/\n/g' | \
   sed -e 's/IL34-0008358/>IL34-0008358/;s/Irf5-0018961/>Irf5-0018961/' | \
   sed -e 's/Klc2-0046729/>Klc2-0046729/' | \
   sed 's/>.*_/>/' | \
    sed 's/SJentinki/Sundasciurus_jentinki/g' | \
    sed 's/Sjentinki/Sundasciurus_jentinki/g' | \
    sed 's/Ill-Rrattus/Rattus_rattus/g' | \
    sed 's/Rnorvegicus/Rattus_norvegicus/g' | \
    sed 's/Ratnorvegicus/Rattus_norvegicus/g' | \
    sed 's/Ratrattus/Rattus_rattus/g' | \
    sed 's/Rrattus/Rattus_rattus/g' |
    sed 's/Ratbaluensis/Rattus_baluensis/g' | \
    sed 's/Rbaluensis/Rattus_baluensis/g' | \
    sed 's/Sunmuelleri/Sundamys_muelleri/g' | \
    sed 's/Smuelleri/Sundamys_muelleri/g' | \
    sed 's/Lcanus/Lenothrix_canus/g' | \
    sed 's/Nivcremoriventer/Niviventer_cremoriventer/g' | \
    sed 's/Ncremoriventer/Niviventer_cremoriventer/g' | \
    sed 's/LencanusG/Lenothrix_canus/g' | \
    sed 's/Lsabanus/Leopoldamys_sabanus/g' | \
    sed 's/Leosabanus/Leopoldamys_sabanus/g' | \
    sed 's/Maxrajah/Maxomys_rajah/g' | \
    sed 's/Maxsurifer/Maxomys_surifer/g' | \
    sed 's/Mochraciventer/Maxomys_ochraceiventer/g' | \
    sed 's/Mochraceiventer/Maxomys_ochraceiventer/g' | \
    sed 's/Mwhiteheadi/Maxomys_whiteheadi/g' | \
    sed 's/Maxwhiteheadi/Maxomys_whiteheadi/g' | \
    sed 's/Cgliroides/Chiropodomys_pusillus/g' | \
    sed 's/Mwhitheadi/Maxomys_whiteheadi/g' | \
    sed 's/Mochraceiventris/Maxomys_ochraceiventer/g' | \
    sed 's/Mspretus/Mus_spretus/g' | \
    sed 's/Apoflavicollis/Apodemys_flavicollis/g' | \
    sed 's/Asylvaticus/Apodemus_sylvaticus/g' | \
    sed 's/Aposylvaticus/Apodemus_sylvaticus/g' | \
    sed 's/Crussula/Crocidura_russula/g' | \
    sed 's/Csuaveolens/Crocidura_suaveolens/g' | \
    sed 's/Setruscus/Suncus_etruscus/g' | \
    sed 's/Hsuillus/Hylomys_suillus/g' | \
    sed 's/Tmontana/Tupaia_montana/g' | \
    sed 's/Ocuniculus/Oryctolagus_cuniculus/g' | \
    sed 's/Equercinus/Elyomys_quercinus/g' | \
    sed 's/Svulgaris/Sundasciurus_vulgaris/g' | \
    sed 's/Cprevostii/Callosciurus_prevostii/g' | \
    sed 's/SunIowii/Sundasciurus_lowii/g' | \
    sed 's/SIowii/Sundasciurus_lowii/g' | \
    sed 's/Severetii/Sundasciurus_everetti/g' | \
    sed 's/Marvalis/Microtus_arvalis/g' | \
    sed 's/Cnivalis/Chionomys_nivalis/g' | \
    sed 's/Mcabrerae/Microtus_cabrerae/g' | \
    sed 's/Asapidus/Arvicola_sapidus/g' | \
    sed 's/Mrcabrerae/Microtus_cabrerae/g' | \
   gawk -f src/functions/wrap-fasta-sequence.awk - > $output
done
