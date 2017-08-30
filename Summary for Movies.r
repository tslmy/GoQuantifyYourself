#install.packages("fmsb")
library(fmsb)
library(readr)
genres <- read_csv("TraktTables/genres.csv")
radarchart(genres, 
           #axistype = 1, #centre axis labels only
           pty = 32,     #do not plot data points
           pfcol = rgb(0.2,0.5,0.5,0.4), #fill color
           pcol = rgb(0.2,0.5,0.5,0.9), #border color
           cglty = 1, #Line type for radar grids
           cglcol = "#dddddddd", #Line color for radar grids
           title = "My Taste in Movies"
)
