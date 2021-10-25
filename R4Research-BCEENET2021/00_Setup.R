# Setup 
## Install packages needed for the workshop 
## 2020-06-15
## ML Gaynor

# Create a list of required packages
list.of.packages <- c("dplyr", # v.0.8.5
                      "tidyr", # v.1.0.2
                      "plyr", # v.1.8.6
                      "spocc", # v.1.0.8
                      "ridigbio", # v.0.3.5
                      "tibble", # v.3.0.0
                      "rbison",
                      "CoordinateCleaner",
                      "lubridate",
                      "ggplot2",
                      "gtools",
                      "leaflet", 
                      "sp", 
                      "rgeos", 
                      "ggspatial", 
                      "raster", 
                      "agricolae", 
                      "gridExtra", 
                     "sf")

# Compare list of required to installed packages
## Retain only missing packages
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

# Run for loop to install any missing packages 
for(i in 1:length(new.packages)){
  install.packages(new.packages[i])
} 

