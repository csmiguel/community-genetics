[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4275481.svg)](https://doi.org/10.5281/zenodo.4275481)

# community-genetics

This repository contains data and code used for phylogenetic analysis in:

Giovanni Forcina, Miguel Camacho-Sanchez, Fred. Y. Y. Tuh, Sacramento Moreno
& Jennifer. A. Leonard. Markers for Genetic Change. Heliyon. accepted.

The goal of the manuscript was to test a panel of genetic markers to evaluate the genetic diversity across the mammal community in two different national parks: Doñana National Park (Spain) and Kinabalu National Park (Malaysia). We further used the genetic data for phylogenetic reconstructions of the Rattini.

The phylogenetic analysis were done using complete [mitochondrial genomes](mitogenomes/tree-reconstruction) and a panel of nuclear markers, mainly introns:
+ **mitochondrial genomes**: fasta files are [here](mitogenomes/tree-reconstruction/mitogenomes.fasta). The code used for annotating the mitochondrial genomes and all the analysis is [here](mitogenomes/tree-reconstruction/readme.md). The analysis resulted in one tree for complete [mitogenomes](mitogenomes/tree-reconstruction/raxml/RAxML_bipartitions.mitogenomes) and another one for [cytochrome b](mitogenomes/tree-reconstruction/cytb/raxml/RAxML_bipartitions.cytb).
+ **nuclear markers**: a species tree was reconstructed from gene trees using Astral. The fasta files are [here](data/raw/fasta.zip). The code is in [src](src), and scripts are numbered by order. Intermediate files are [here](data/intermediate), and final tree with Astral is [here](data/intermediate/astral/output).

*In its current version the repository might not fully reproducible due to changes in relative paths between version changes.*