#Please open this file in RStudio, and click the "Source" button (on the top-right corner of the script editor) to properlytun the code.
this.dir <- dirname(parent.frame(2)$ofile) # should be something like "~/Projects/TimeManagement/" on my mac.
setwd(this.dir)

# Install package ggplot2
#install.packages("ggplot2")
# Load package ggplot2
library(ggplot2)

# Install package ggplot2
#install.packages("readr")
# Load package readr
library(readr)

#install.packages("lubridate")
# Load package lubridate
library(lubridate)

# draw:

# (1) TimeTable:
#     Load the data:
data_log <- read_csv("MovesTables/storyline.csv", 
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
  scale_x_date(   date_breaks = "2 month", date_labels = "%b %Y", expand=c(0,0)) +
  labs( x = "Date", y = "Time",
        title ="Data Exported from Moves",
        subtitle = "Logs of How I Spent My Time Moving Around",
        caption = "Made by Mingyang Li")

ggsave("Plots/Waterfall_Moves.pdf", plot = last_plot())
