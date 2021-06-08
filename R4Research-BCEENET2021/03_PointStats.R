# Point Stats
## Point sample and run a simple ANOVA.
## 2020-06-15
## ML Gaynor

# Load Packages
library(gtools)
library(raster)
library(dplyr)
library(tibble)
library(agricolae)
library(gridExtra)

# Read data files
dfS <- read.csv("data/Shortia_galacifolia_061521-cleaned.csv")
dfG <- read.csv("data/Galax_urceolata_061521-cleaned.csv")

## Combined the two df
df <- rbind(dfS, dfG)

## Subset spatial points
pts <- SpatialPoints(df[,7:6])

# List bioclim files
list <- list.files("data/bio/", 
                    full.names = TRUE,
                    recursive = FALSE)

## Order list using gtools
list <- mixedsort(sort(list))

## Load the rasters 
envtStack <- raster::stack(list)

# Point Sample
## Extract value for each point
ptExtracted <- raster::extract(envtStack, pts)

## Convert to data frame
ptExtracteddf <- as.data.frame(ptExtracted)

## Add species name
ptExtracteddf <- ptExtracteddf %>%
                 mutate(name = as.character(df$name))

# ANOVA 
## Analysis of variance 
### lm set the linear model 
### aov runs the anova
bio1aov <- aov(lm(ptExtracteddf[, 1] ~ name, data = ptExtracteddf))
bio1aov

## Tukey HSD test
### multiple comparisons of treatments by means of Tukey
b1 <- HSD.test(bio1aov, trt = "name", alpha = 0.05)        

### Separate the groups
bio1_group <- b1$groups
bio1_group <- rownames_to_column(bio1_group, var = "name")
bio1_group <- bio1_group %>%
              select(name, groups)
## Make plot
### Subset the name and bio_1 column from the original df
part <- ptExtracteddf %>%
        dplyr::select(name, bio_1)

### Join the subset df to the bio1_group data frame
bio1pl <- left_join(part, bio1_group, by = "name")

### Plot
bio1_aov_plot <- ggplot(bio1pl, aes(x = name, y = bio_1)) +
                  geom_boxplot(aes(fill = groups)) +
                  geom_text(data = bio1_group, 
                            mapping = aes(x = name,
                                          y = 20, 
                                          label = groups), 
                            size = 5, inherit.aes = FALSE) +
                  theme(axis.text.x = element_text(angle = 90, 
                                                   size = 8, 
                                                   face = 'italic'))
bio1_aov_plot

# Loop through all variables
variablelist <- colnames(ptExtracteddf)[1:20]
plotlist <- c()
for(i in 1:20){
      bioaov <- aov(lm(ptExtracteddf[, i] ~ name, data = ptExtracteddf))
      b <- HSD.test(bioaov, trt = "name", alpha = 0.05)    
      bio_group <- b$groups
      bio_group <- rownames_to_column(bio_group, var = "name")
      bio_group <- bio_group %>%
                   select(name, groups)
      part <- ptExtracteddf %>%
              dplyr::select(name, variablelist[i])
      biopl <- left_join(part, bio_group, by = "name")
      plotlist[[i]] <- ggplot(biopl, aes(x = name, y = biopl[,2])) +
                       geom_boxplot(aes(fill = groups)) +
                       geom_text(data = bio_group, 
                                mapping = aes(x = name,
                                              y = (max(na.omit(biopl[,2]))* 1.3), 
                                              label = groups), 
                                size = 5, inherit.aes = FALSE) +
                               scale_x_discrete(labels = c('G', 'S')) +
                       ggtitle(label  = paste(variablelist[i]))
      
}

gridExtra::grid.arrange(grobs = plotlist)
