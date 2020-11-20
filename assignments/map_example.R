# Public Interest Data Lab 2020
# A little bit of mapping
# 2020-11-20
# mpc


# 0. Set up ----
library(tidyverse)
library(tidycensus)
library(sf) # "simple features" for spatial data


# 1. Load data ----
tracts <- readRDS("data/tracts.RDS")
ref <- readRDS("data/referrals_clean.RDS")

# I didn't download the geometry (geographic coordinates) of the census 
# data last time, so will grab that here, along with the number of residents
# under 18.

# get data and geometry: under 18 population
tract_18 <- get_acs(geography = "tract", table = "B09001", 
                    state = "VA", county = "003", 
                    year = 2018, survey = "acs5",
                    geometry = TRUE, cache_table = TRUE)

tract_18 <- tract_18 %>% 
  filter(variable == "B09001_001") %>% 
  rename(childpopE = estimate, childpopM = moe) %>% 
  select(-variable)
  
# add to tracts
tracts <- left_join(tract_18, tracts)


# 2. Derive referral counts by tract and add
tract_ref <- ref %>% filter(!(is.na(tract))) %>% 
  count(geoid) %>% mutate(GEOID = as.character(geoid))

# add to tracts and generate ratio
tracts <- tracts %>% left_join(tract_ref)
tracts <- tracts %>% mutate(refrate = round((n/childpopE)*100,0))


# 2. Create map with ggplot2 ----
# other mapping possibilities: leaflet, tmap

# Get center coordinates for labeling
tracts <- tracts %>%
  mutate(tractid = str_sub(GEOID, 7,11),
         tractid = as.numeric(tractid),
         tractid = paste0("(",tractid,")"),
    lon = map_dbl(geometry, ~st_centroid(.x)[[1]]),
    lat = map_dbl(geometry, ~st_centroid(.x)[[2]]))


# map theme
theme_map <- function(...) {
  theme_minimal() +
    theme(
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      # panel.grid.minor = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.major = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "#f5f5f2", color = NA), 
      panel.background = element_rect(fill = "#f5f5f2", color = NA), 
      legend.background = element_rect(fill = "#f5f5f2", color = NA),
      panel.border = element_blank(),
      ...
    )
}

# Number of children by tract
ggplot(tracts, aes(fill = childpopE)) + 
  geom_sf(color = "white") +
  theme_map() +
  scale_fill_gradient(name = "Child Pop", low = "#9ecae1", high = "#08306b") +
  labs(x = NULL, 
       y = NULL, 
       title = "Albemarle County: Child Population by Census Tract", 
       subtitle = "Population Estimates from 2014-2018 American Community Survey") +
  # geom_text(aes(x=lon, y=lat, label=tractid), size = 3, color = "white",
  #           position = position_nudge(y = -0.01)) +
  geom_text(aes(x=lon, y=lat, label=childpopE), size = 3, color = "white",
            position = position_nudge(y = 0.001))

# Referral rate by tract
ggplot(tracts, aes(fill = refrate)) + 
  geom_sf(color = "white") +
  theme_map() +
  scale_fill_gradient(name = "Referral Rate", low = "#9ecae1", high = "#08306b") +
  labs(x = NULL, 
       y = NULL, 
       title = "Albemarle County: Referrals per 100 Children by Census Tract", 
       subtitle = "Population Estimates from 2014-2018 American Community Survey") +
  # geom_text(aes(x=lon, y=lat, label=tractid), size = 3, color = "white",
  #           position = position_nudge(y = -0.01)) +
  geom_text(aes(x=lon, y=lat, label=refrate), size = 3, color = "white",
            position = position_nudge(y = 0.001))



# 3. leaflet map example ----
# (for zooming, and fun)
library(leaflet)
library(RColorBrewer)
# https://rstudio.github.io/leaflet/

# define popup info
popup <- paste0("Child Pop: ", tracts$childpopE,
                "<br>", "Referrals: ", tracts$n,
                "<br>", "Referral Rate: ", tracts$refrate,
                "<br>", "Tract: ", tracts$NAME)

min <- min(tracts$refrate, na.rm = TRUE)
max <- max(tracts$refrate, na.rm = TRUE)

# define palette
nb.cols <- 10 # number of colors
mycolors <- colorRampPalette(brewer.pal(8, "YlGnBu"))(nb.cols)
pal <- colorNumeric(palette = mycolors,
                    domain = min:max)

# create map
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  # addTiles() %>% # to show streets more prominently
  addPolygons(data = tracts,
              fillColor = ~pal(tracts$refrate),
              fillOpacity = 0.5,
              color = "white",
              weight = 2,
              smoothFactor = 0.2,
              popup = popup,
              highlight = highlightOptions(
                weight = 5,
                fillOpacity = 0.7,
                bringToFront = TRUE)) %>%
  addLegend(pal = pal,
            values = tracts$refrate,
            position = "bottomright",
            opacity = 0.5,
            title = "Referral Rate by Tract")
            