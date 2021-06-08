# Using R for Digitized Natural History Collections (dNHC) in Research        
Workshop material for BCEENET 2021 Virtual Meeting.

**Date**: June 15th, 2021, 2:00pm - 4:00pm     
**Length**: 2 hours. 

# Workshop Goal   
This workshop reviews cleaning, mapping, and analyzing natural history collections data in R. It will review point sampling and extracting elevation data from occurrence records, as well as how to run an ANOVA based on this data.

# Pre-workshop.  
Before this workshop, make sure to at least download the R4dNHC folder (which I compressed for easy download). This has all the necessary datafiles and functions needed to run through the workshop during the session. Make sure to run through the 00_Setup.R script as well to make sure all needed packages are installed. 


# File Information 
The **R4dNHC/** folder does not contain 01_CleaningData.R., 02_Mapping.R, 03_PointStats.R - which I plan to live code during the workshop.  

The **R4Research-BCEENET2021/** folder contains all scripts and some extras:  
00_Setup.R.    
- Download and install needed packages. 
    
01_CleaningData.R.  
- Downloading and cleaning data     
   
02_Mapping.R 
- Making maps with ggplot2 and leaflet. 

03_PointStats.R.   
- Point sampling   
    - Including extracting elevation data     
- Analysis of Variance or ANOVA. 

Extra.R
- Script used to decrease size of BioClim files  

**functions/**  
- includes script needed for 01_CleaningData.R.   

**data/**  
- **bio/** includes elevation and BioClim rasters which I downloaded from [WorldClim](https://www.worldclim.org/data/worldclim21.html). 
- list_of_wants.csv is used by the spocc_combine function.  
- Galax_urceolata_raw.csv and Shortia_galacifolia_raw.csv are the downloaded occurrence records for *Galax urceolata* and *Shortia galacifolia* prior to cleaning.   
- Galax_urceolata_061521-cleaned.csv and Shortia_galacifolia_061521-cleaned.csv are the cleaned occurrence records.   

**R4Research.html**
- this is an html version of all the scripts in this folder.  
- this can be opened in a web browser and is a good place to start if you are an R novice.       
- For those wanting to modify this html for other uses - to make this file you knit **R4Research.Rmd**.  


