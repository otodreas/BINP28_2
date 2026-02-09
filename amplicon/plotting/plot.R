# renv::init()
# renv::install("here")
# renv::install("tidyverse")

library(here)
library(tidyverse)

df <- as_tibble(
    read.csv(here("7_classify", "all.fixedRank"), header = FALSE, sep = "\t")
) %>%
  select(!V2)
colnames(df) <- 
