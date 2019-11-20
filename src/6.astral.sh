#make directory for Astral files
mkdir data/intermediate/astral
rm data/intermediate/astral/*

#put all trees on a same file
cat data/intermediate/raxml/*best* > data/intermediate/astral/input.tre
#issue all trees should have the same tips
java -jar src/Astral/astral.5.6.3.jar \
-i data/intermediate/astral/input.tre \
-o data/intermediate/astral/output
