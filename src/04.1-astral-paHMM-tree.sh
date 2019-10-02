#make directory for Astral files
mkdir data/intermediate/astral-paHMMtree
rm data/intermediate/astral-paHMMtree/*

#put all trees on a same file
cat data/intermediate/paHMM-Tree/*.tree > data/intermediate/astral-paHMMtree/input.tre
#issue all trees should have the same tips
java -jar src/Astral/astral.5.6.3.jar \
-i data/intermediate/astral-paHMMtree/input.tre \
-o data/intermediate/astral-paHMMtree/output
