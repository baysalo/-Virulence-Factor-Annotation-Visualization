# =========================================================================
# TITLE: PHI-base Virulence Factor Annotation & Visualization
# AUTHOR: Omur Baysal Ph.D. Professor of Molecular Microbiology and Genetics 
# DESCRIPTION: Merges BLAST results with PHI-base metadata to categorize
#              virulence factors by protein function and phenotype.
# =========================================================================

# Load required libraries
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

# -------------------------------------------------------------------------
# 1. LOAD DATASETS
# -------------------------------------------------------------------------

# Load your local hit data (e.g., Final_Annotated_Effectors.csv)
# Ensure this file contains a column for PHI-base IDs (e.g., 'PHI_Hit')
my_data <- read.csv("Final_Annotated_Effectors.csv", stringsAsFactors = FALSE)

# Select the Master Metadata file (phi-base_current.csv, approx. 5MB)
# Note: Download this from https://github.com/PHI-base/data
message("Please select the 'phi-base_current.csv' file in the pop-up window...")
phi_master <- read.csv(file.choose())

# -------------------------------------------------------------------------
# 2. DATA CLEANING & STANDARDIZATION
# -------------------------------------------------------------------------

# Standardize PHI IDs to numbers only to ensure a 100% match
my_data$PHI_Hit <- gsub("[^0-9]", "", as.character(my_data$PHI_Hit))
phi_master[[1]] <- gsub("[^0-9]", "", as.character(phi_master[[1]]))
colnames(phi_master)[1] <- "PHI_Hit"

# Merge local hits with the master functional metadata
final_annotated <- inner_join(my_data, phi_master, by = "PHI_Hit")

# Check if the merge was successful
if(nrow(final_annotated) == 0) {
  stop("Merge failed: 0 matching IDs. Ensure PHI-base Master file is selected.")
}

# -------------------------------------------------------------------------
# 3. DYNAMIC COLUMN DETECTION
# -------------------------------------------------------------------------

# Automatically detect functional or phenotype columns to avoid manual errors
target_col <- grep("function|phenotype|description", 
                   colnames(final_annotated), 
                   ignore.case = TRUE, 
                   value = TRUE)[1]

if (is.na(target_col)) {
  stop("Could not find a functional metadata column in the merged data.")
}

# -------------------------------------------------------------------------
# 4. VISUALIZATION 
# -------------------------------------------------------------------------

# Process top 15 categories for a clean, readable chart
plot_data <- final_annotated %>%
  filter(!is.na(.data[[target_col]]) & .data[[target_col]] != "") %>%
  count(.data[[target_col]], sort = TRUE) %>%
  slice_head(n = 15)

# Generate horizontal bar chart using a scientific journal theme
pub_plot <- ggplot(plot_data, aes(x = reorder(.data[[target_col]], n), y = n, fill = n)) +
  geom_col(color = "black", width = 0.7) +
  coord_flip() +
  scale_fill_viridis_c(option = "mako") + # Professional scientific palette
  theme_bw(base_size = 14) +
  labs(
    title = paste("Top 15 Virulence Categories by", target_col),
    subtitle = "Analysis of Bacterial Plant Pathogen Effectors",
    x = "Biological Category",
    y = "Gene Count"
  ) +
  theme(
    legend.position = "none",
    axis.text.y = element_text(size = 10, face = "bold")
  )

# Display and Save High-Resolution Outputs
print(pub_plot)
ggsave("Pathogen_Analysis_300dpi.png", plot = pub_plot, width = 12, height = 8, dpi = 300)
write.csv(final_annotated, "Final_Annotated_Full_Results.csv", row.names = FALSE)

message("Analysis Complete. PNG and CSV results saved to current directory.")
