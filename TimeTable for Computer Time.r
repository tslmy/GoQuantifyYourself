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

#install.packages("sunburstR")
# Load package sunburstR
library(sunburstR)

## Install package ggsunburst
#if (!require("ggplot2")) install.packages("ggplot2")
#if (!require("rPython")) install.packages("rPython")
#install.packages("http://genome.crg.es/~didac/ggsunburst/ggsunburst_0.0.6.tar.gz", repos=NULL, type="source")
## Load package ggsunburst
#library(ggsunburst)

# draw:

# (1) TimeTable:

data_log <- read_csv("QbserveTables/log.csv", 
                     col_types = cols(date = col_date(format = "%Y-%m-%d")))

ggplot(data = data_log, aes(x = date, y = duration)) + 
  geom_bar(stat = "identity", fill=data_log$color) + 
  # now remove background elements -- from http://felixfan.github.io/ggplot2-remove-grid-background-margin/:
  theme(panel.grid.major = element_blank(), # no major gridlines
        panel.grid.minor = element_blank(), # no minor gridlines
        panel.background = element_blank() # no background
        #axis.title = element_blank(), # no axis labels
        #axis.line = element_blank() # no axis lines # = element_line(colour = "black")
        )+
  scale_y_reverse()+#function(x) seconds_to_period(x))#strftime(chron(times=c(x/86400)), "%H:%M"))#+coord_flip()
  coord_cartesian(ylim = c(0, 24), expand = FALSE)+
  labs( x = "Date", y = "Time (Hour)",
        title ="Timetable Waterfall",
        subtitle = "Logs of How I Spent My Time on My Laptop",
        caption = "Made by Mingyang Li")

ggsave("Plots/Waterfall_ComputerTime.pdf", plot = last_plot())


# (2) Portion:
data_totals <- read_csv("QbserveTables/totals.csv",
                        col_types = cols(#duration = col_time(format = "%H:%M:%S"), 
                        date = col_date(format = "%Y-%m-%d")),
                        trim_ws = TRUE)

ggplot(data = data_totals, aes(x = date, y = duration, fill=type)) + 
  geom_area() +  # add `position = "fill",` to make it percentage ;)
  coord_cartesian(ylim = c(0, 24), expand = FALSE)+
  labs( x = "Date", y = "Duration (Hour)",
        title ="Hours Spent by Type",
        subtitle = "Area Plot of How My Hours on My Laptop Are Spent",
        caption = "Made by Mingyang Li")+
  scale_fill_manual(values = c("#FD7084","#34C3DB","#A9EA5D"))+
  theme(legend.position = "right")

ggsave("Plots/Flow_ComputerTime.pdf", plot = last_plot())


# (3) Last-Day Pie Chart:
# # Don't use ggsunburst, because its sector sizes cannot vary with data:
# extract data from the newick string defined above
#sb <- sunburst_data(read_file("QbserveTables/2017-06-08.nw"))
#sunburst(sb)

data_lastDay <- read_csv("QbserveTables/2017-06-08.csv", 
                         col_names = FALSE)
#data_lastDay_colors <- read_csv("QbserveTables/2017-06-08_colors.csv", 
#                         col_names = TRUE)
#legend_items <- data_lastDay_colors[[1]]
legend_items <- c("productive", "neutral", "distracting", "away")#unique(unlist(strsplit(data_lastDay[[1]], '-')))
legend_items <- unique(c(legend_items,
                         unlist(strsplit(data_lastDay[[1]], '-'))))
#color = data_lastDay_colors[[2]]
color = c("A9EA5D", "34C3DB", "FD7084", "FFFFFF")
color <- c(color,
           sample(colorRampPalette(brewer.pal(12, 'Set3'))(length(legend_items)-4)))
sunburst(data_lastDay, 
         #legendOrder=legend_items, 
         colors = list(
           range=color,
           domain=legend_items
         ))

  
  