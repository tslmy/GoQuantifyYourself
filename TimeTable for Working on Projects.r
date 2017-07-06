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
library(scales)

# draw:

# (1) TimeTable:
data_log <- read_csv("TogglTables/data.csv",  # Load the data
                      col_types = cols(date = col_date(format = "%Y-%m-%d"), 
                                        end = col_time(format = "%H:%M:%S"), 
                                      start = col_time(format = "%H:%M:%S")))
#     convert column data types to POSIXct:
data_log$start <- as.POSIXct(data_log$start, format = "%H:%M:%S")
data_log$end <- as.POSIXct(data_log$end, format = "%H:%M:%S")
#     A function to combine transformations for axes-scales, from http://howtoprogram.eu/question/n-a,68740 :
c_trans <- function(a, b, breaks = b$breaks, format = b$format) {
  a <- as.trans(a)
  b <- as.trans(b)
  name <- paste(a$name, b$name, sep = "-")    # set the name of the new transformation
  trans <- function(x) a$trans(b$trans(x))    # nest the 2 transformations a and b 
  inv <- function(x) b$inverse(a$inverse(x))  # register their inverse steps as well
  trans_new(name, trans, inv, breaks, format) # create the new transformation using scales::trans_new
}
rev_date <- c_trans("reverse", "time", format=date_format("%H:%M"))
#     Draw:
#lims <- as.POSIXct(c("00:00:00","23:59:59"), format = "%H:%M:%S")
ggplot(data_log) +
  geom_rect(aes(xmin = date - 0.5,    xmax = date + 0.5,
                ymin = start,         ymax = end,
                fill = name)) + 
  scale_y_continuous(trans = rev_date, expand=c(0,0)) + 
  scale_x_date(   date_breaks="2 month", date_labels="%b %Y", expand=c(0,0)) +
  labs( x = "Date", y = "Time (Hour)",
        title ="Data Exported from Toggl",
        subtitle = "Logs of How I Spent My Time Working on Projects",
        caption = "Made by Mingyang Li")

ggsave("Plots/Waterfall_Projects.pdf", plot = last_plot())

