# Mapping
## Map occurrence records using ggplot2 and leaflet.
## 2020-06-15
## ML Gaynor

# Load Packages
library(ggplot2)
library(leaflet)
library(sp)
library(rgeos)
library(ggspatial)

# Read data file
df <- read.csv("data/Shortia_galacifolia_061521-cleaned.csv")
df_fixed <- st_as_sf(df, coords = c("long", "lat"), crs = 4326)

# Map using ggplot2
## Simple Map

## Set base maps
### Here we download a USA map, a state level USA map, and a county level USA map. 
USA <- borders(database = "usa", colour = "gray50", fill = "gray50")
states <-  borders("state", colour = "black", fill = NA)
county <- borders(database = "county", colour = "gray40", fill = NA)

## Plot using ggplot2
### Here we are going to add our USA map and the occurrence points
### Next, we zoom into our area of interest
### Then we fix the x and y labels
### Finally, we add a scale and a north arrow
simple_map <- ggplot() +
              USA +
              # Better to add state or county here - order matters! 
              geom_sf(df_fixed, 
                         mapping = aes(col = name), 
                         col = "blue") +
              coord_sf(xlim = c(-86, -76), ylim = c(30, 38)) +
              xlab("Longitude") +
              ylab("Latitude") +
              annotation_scale() +
              annotation_north_arrow( height = unit(1, "cm"),
                                      width = unit(1, "cm"), 
                                      location = "tl")

simple_map

### Add States
simple_map + states

### Add Counties
simple_map + county


# Map using Leaflet
## Make points spatial 
pts <- SpatialPoints(df[,7:6])

## Make a simple leaflet map
m <- leaflet(pts) %>% 
     addCircles() %>% 
     addTiles() 
m

### Set extent and zoom out
m <- fitBounds(m, -86, 30, -76, 38)
m

### Make fancy icon
ShortiaIcon <- makeIcon(
  iconUrl = "https://live.staticflickr.com/2914/32392790054_27192e77e6_b.jpg",
  iconWidth = 18, iconHeight = 28,
  iconAnchorX = 17, iconAnchorY = 27
)

m <- leaflet(pts) %>% 
     addTiles()  %>% 
     addMarkers(icon = ShortiaIcon) 
m

### Add label to see long, lat
m <- leaflet(pts) %>% 
     addTiles()  %>% 
     addMarkers(label = paste0(df$long, ", ", df$lat))  
m 

### Add rectangle marking extent
m <- leaflet(pts) %>% 
     addTiles()  %>% 
     addMarkers(label = paste0(df$long, ", ", df$lat))   %>%
     addRectangles(
        lng1 = max(df$long), lat1 = max(df$lat),
        lng2 = min(df$long), lat2 = min(df$lat),
        fillColor = "transparent")
m
