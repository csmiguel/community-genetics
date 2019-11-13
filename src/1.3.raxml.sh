mkdir data/intermediate/raxml
rm data/intermediate/raxml/*

p=$(pwd)
for i in data/intermediate/trimal/*phy
do
outputdir=$(echo $i | sed 's/trimal.*$/raxml/')
outputname=$(echo $i | sed 's/.*\/\(.*\).trimal.phy/\1/')
raxml -f a -m GTRGAMMA -p 12345 -x 12345 -N 100 -s "$i" -n $outputname -T2 -w $p/$outputdir
done
