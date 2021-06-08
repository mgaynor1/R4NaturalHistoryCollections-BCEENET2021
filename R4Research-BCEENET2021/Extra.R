# Extra processing
## This script was used to decrease the size of the BioClim file prior to sharing. 
## 2020-06-15
## ML Gaynor

# Load packages
library(raster)

# Load file list
biolist <- list.files("data/wc2.1_30s_bio/", pattern = "*.tif", full.names = TRUE)

# Set extent
e <- extent(-86.96, -76.55, 33.54, 37.42)

# Set function for clipping 
path <- "data/bio/"
end <- ".asc"
clip <- function(file){
  # Read in raster
  rast <- raster(file)
  # Setup file names
  name <- names(rast)
  name <- sub("wc2.1_30s_", "", name)
  out <- paste0(path, name)
  outfile <- paste0(out, end)
  # Crop
  c <- crop(rast, extent(e))
  # Write raster
  writeRaster(c, outfile, format = "ascii")
}

# Loop through list of files
for(i in 1:length(biolist)){
  clip(biolist[i])
}




