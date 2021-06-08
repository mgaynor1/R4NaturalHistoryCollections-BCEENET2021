# Cleaning Data
## Download data and clean it.
## 2020-06-15
## ML Gaynor

# Load Packages
library(CoordinateCleaner)
library(lubridate)

# Load Functions
source("functions/DownloadingDataMore.R")

# Download Shortia galacifolia 
## Use spocc_combined to create a csv containing occurrence records from iDigBio, GBIF, and BISON. 
spocc_combine("Shortia galacifolia", "data/Shortia_galacifolia_raw.csv")

## Read in downloaded data frame
rawdf <- read.csv("data/Shortia_galacifolia_raw.csv")

# Cleaning 
## Inspect dataframe  
### What columns are included?  
names(rawdf)

### How many observations do we start with?
nrow(rawdf)

# 1. Resolve taxon names  
## Inspect scientific names included in the raw df.  
unique(rawdf$name)

## Create a list of accepted names based on the name column in your dataframe
search <-  c("Shortia galacifolia")

## Filter to only include accepted namesUsing the R package dplyr, we:
### 1. filter the dataframe to only include rows with the accepted names
### 2. filter out any rows with NA for dwc.scientificName.
### 3. create a column called name and set it equal to“Shortia galacifolia”
df <- rawdf %>% 
      filter(grepl(search, name, ignore.case =  TRUE)) %>% 
      mutate(new.name = "Shortia galacifolia")

## How many observations do we have now?
nrow(df)

# 2. Decrease number of columns
## Merge the two locality columns
df$Latitude <-  dplyr::coalesce(df$Latitude, df$spocc.latitude)
df$Longitude <-  dplyr::coalesce(df$Longitude, df$spocc.longitude)

## Merge the two date columns
df$date <-  dplyr::coalesce(df$date, df$spocc.date)

## Subset columns
### Using the R package dplyr, we select and rename columns.
df <- df %>% 
      dplyr::select(ID = ID,
                name = new.name,
                basis = basis,
                coordinateUncertaintyInMeters = coordinateUncertaintyInMeters,
                informationWithheld = informationWithheld,
                lat = Latitude,
                long = Longitude,
                date = date)

# 3. Clean localities
### Using the R package dplyr, we:
#### 1. filter out(!) any rows where long ‘is.na’
#### 2. filter out(!) any rows where lat ‘is.na’
df <- df %>% 
      filter(!is.na(long)) %>% 
      filter(!is.na(lat))

## How many observations do we have now?
nrow(df)

## Precision
### Using the R base function ‘round’, we round lat and long to two decimal places
df$lat <- round(df$lat, digits = 2)
df$long <- round(df$long, digits = 2)

## Remove unlikely points
### Remove points at 0.00, 0.00
#### Using the R package dplyr, we:
##### 1. filter to retain rows where long is NOT(!) equal to 0.00 
##### 2. filter to retain rows where long is NOT(!) equal to 0.00
df <- df %>% 
      filter(long != 0.00) %>% 
      filter(lat != 0.00)


### Remove coordinates in cultivated zones, botanical gardens, and outside our desired range
#### Using the R package CoordinateCleaner, we first if points are 
#### at biodiversity institutions and remove any points that are occurring at institutions. 
df <- cc_inst(df, 
              lon = "long",
              lat = "lat",
              species = "name")

#### Next, we look for geographic outliers and remove outliers.
df <- cc_outl(df,
              lon = "long",
              lat = "lat",
              species = "name")

## How many observations do we have now?
nrow(df)

# 4. Remove Duplicates
## Fix dates
### Using the R package lubridate, we first parse the date into the same format.
df$date <- lubridate::ymd(df$date)

### Next you are going to seperate date into year, month, and day - 
#### where every column only contains one set ofinformation.
df <- df %>% 
      dplyr::mutate(year = lubridate::year(date),
                month = lubridate::month(date),
                day = lubridate::day(date))

## Remove rows with identical lat, long, year, month, and day
### If a specimen shares lat, long, and event date
### we are assuming that it is identical. Many specimen lack date 
## and lat/long, so this may be getting rid of information you would want to keep.
df <- distinct(df, lat, long, year, month, day, .keep_all = TRUE)

## How many observations do we have now?
nrow(df)

# 5. Save Cleaned .csv
write.csv(df, "data/Shortia_galacifolia_061521-cleaned.csv", row.names = FALSE)
