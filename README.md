# -Virulence-Factor-Annotation-Visualization
Virulence Factor Annotation for bacterial plant pathogens 
Virulence Factor Analysis of a Bacterial Plant Pathogen
Project Overview
This repository contains a bioinformatics pipeline designed to annotate and visualize putative virulence factors in a bacterial plant pathogen. By leveraging the Pathogen-Host Interactions Database (PHI-base), this project identifies genes experimentally verified to be involved in pathogenicity, such as effectors, toxins, and cell-wall degrading enzymes.

Repository Structure
Final_Annotated_Effectors.csv: The local BLAST results mapping genomic sequences to PHI-base accessions.

pathogen_analysis.R: The primary R script for data cleaning, database merging, and figure generation.

Results/: Directory containing high-resolution (300 DPI) visualizations.

Requirements
To run this analysis, you will need:

R (version 4.0 or higher)

RStudio

R Packages: tidyverse (includes ggplot2, dplyr, stringr)

Getting Started
1. Download PHI-base Master Metadata
Due to file size constraints, the PHI-base master database is not included in this repository.

Visit the PHI-base GitHub Data Repository.

Download the phi-base_current.csv file (approx. 5MB).

2. Run the Analysis
Open pathogen_analysis.R in RStudio.

Run the script. When prompted by the pop-up window, select the phi-base_current.csv file you just downloaded.

The script will automatically perform an inner_join to annotate your sequences with biological functions and mutant phenotypes.

Methodology
The pipeline implements the following steps:

ID Standardization: Cleans PHI-base IDs to ensure a 100% match between local BLAST hits and the master database.

Dynamic Column Detection: Automatically identifies functional metadata columns (e.g., Protein.function or Mutant.phenotype) to prevent script failures.

Filtering: Visualizes the Top 15 categories to ensure clarity and scannability for scientific publication.
