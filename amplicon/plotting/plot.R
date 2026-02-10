# Mount libraries
library(here)
library(tidyverse)

# Load data (if reproducing results you might need to adjust filepaths)
classific <- as_tibble(
  read.csv(here("amplicon", "7_classify", "all_trim.fixedRank.csv"))
)
otus <- as_tibble(
  read.csv(here("amplicon", "6_clustering", "otus.tsv"), sep = "\t")
)

# Create joined dataframe
data <- classific %>%
  left_join(otus, by = c("OTU" = "X.OTU.ID")) %>%
  pivot_longer(
    cols = -c(OTU, Phylum), names_to = "Sample", values_to = "Abundance"
) %>%
  select(-OTU) %>%
  # Calculate abundance in %
  group_by(Sample) %>%
  mutate(Percentage = Abundance / sum(Abundance) * 100) %>%
  ungroup()

# Plot
ggplot(data, aes(x = Sample, y = Percentage, fill = Phylum)) +
  geom_col() +
  labs(x = "Sample", y = "Relative Abundance (%)") +
  theme_minimal()
