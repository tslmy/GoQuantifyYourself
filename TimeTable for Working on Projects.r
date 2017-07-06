#Please open this file in RStudio, and click the "Source" button (on the top-right corner of the script editor) to properlytun the code.
this.dir <- dirname(parent.frame(2)$ofile) # should be something like "~/Projects/TimeManagement/" on my mac.
setwd(this.dir)

## Install the colormap package on https://bhaskarvk.github.io/colormap/
#if(!require("V8")) install.packages("V8")
#if(!require("devtools")) install.packages("devtools")
#if(!require("colormap")) devtools::install_github("bhaskarvk/colormap")

# Install the iWantHue package from GitHub Gist <https://gist.github.com/Pakillo/46aab85863d17acd2de0>:
# devtools::source_gist('45b49da5e260a9fc1cd7', filename = "iWantHue.R")
# Had to save this to local, because I'm now on a Wi-Fi-less train:
source("iwanthue.r")

# Load libraries:
library(ggplot2)
library(readr)
library(plyr)

# draw:

# (1) TimeTable:
data_log <- read_csv("TogglTables/data.csv",  # Load the data
                      col_types = cols(date = col_date(format = "%Y-%m-%d"), 
                                        end = col_time(format = "%H:%M:%S"), 
                                      start = col_time(format = "%H:%M:%S")))

data_log$start <- as.POSIXct(data_log$start, format = "%H:%M:%S")
data_log$end <- as.POSIXct(data_log$end, format = "%H:%M:%S")

ggplot(data_log) +
  geom_rect(aes(xmin = date - 0.5,    xmax = date + 0.5,
                ymin = start,         ymax = end,
                fill = name)) + 
  scale_y_datetime(date_labels = "%H:%M") + 
  #coord_cartesian(ylim = c(0, 24), expand = FALSE)+
  scale_x_date(date_breaks = "2 month", date_labels = "%b %Y") +
  labs( x = "Date", y = "Time (Hour)",
        title ="Data Exported from Toggl",
        subtitle = "Logs of How I Spent My Time Working on Projects",
        caption = "Made by Mingyang Li")

ggsave("Plots/Waterfall_Projects.pdf", plot = last_plot())

