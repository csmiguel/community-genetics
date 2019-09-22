mkdir data/intermediate/raxml
rm data/intermediate/raxml/*

p=$(pwd)
for i in data/intermediate/msa/*phy
do
outputdir=$(echo $i | sed 's/msa.*$/raxml/')
outputname=$(echo $i | sed 's/.*\/\(.*\).fa-out.phy/\1/')
echo $outputname
echo $outputdir
raxml -f a -m GTRGAMMA -p 12345 -x 12345 -N 100 -s "$i" -n $outputname -T2 -w $p/$outputdir
done
