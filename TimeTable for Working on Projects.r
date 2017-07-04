#Please open this file in RStudio, and click the "Source" button (on the top-right corner of the script editor) to properlytun the code.
this.dir <- dirname(parent.frame(2)$ofile) # should be something like "~/Projects/TimeManagement/" on my mac.
setwd(this.dir)

## Install the colormap package on https://bhaskarvk.github.io/colormap/
#if(!require("V8")) install.packages("V8")
#if(!require("devtools")) install.packages("devtools")
#if(!require("colormap")) devtools::install_github("bhaskarvk/colormap")

# Install the iWantHue package from GitHub Gist:
devtools::source_gist('45b49da5e260a9fc1cd7', filename = "iWantHue.R")

# Load libraries:
library(ggplot2)
library(readr)
library(plyr)

# draw:

# (1) TimeTable:
#     Load the data:
data_log <- read_csv("TogglTables/data.csv", 
                      col_types = cols(date = col_date(format = "%Y-%m-%d"), 
                                        end = col_time(format = "%H:%M:%S"), 
                                      start = col_time(format = "%H:%M:%S")))

#    Define the palatte:
tasks = unique(data_log$name)
tasks = tasks[tasks != "idle"] # to remove the "idle" one
tasks_count = length(tasks)
tasks_color = iwanthue(tasks_count)
# then add the "idle" item back:
tasks = c(tasks, c("idle"))
tasks_color = c(tasks_color, c("#ffffff00"))
# apply the colors:
data_log$color <- mapvalues(data_log$name, from=tasks, to=tasks_color)

ggplot(data = data_log, aes(x = date, y = duration)) + 
  geom_bar(stat = "identity", fill=data_log$color) + 
  # now remove background elements -- from http://felixfan.github.io/ggplot2-remove-grid-background-margin/:
  #theme(panel.grid.major = element_blank(), # no major gridlines
        #panel.grid.minor = element_blank(), # no minor gridlines
        #panel.background = element_blank() # no background
        #axis.title = element_blank(), # no axis labels
        #axis.line = element_blank() # no axis lines # = element_line(colour = "black")
        #)+
  scale_y_reverse(breaks=0:24)+#function(x) seconds_to_period(x))#strftime(chron(times=c(x/86400)), "%H:%M"))#+coord_flip()
  coord_cartesian(ylim = c(0, 24), expand = FALSE)+
  labs( x = "Date", y = "Time (Hour)",
        title ="Data Exported from Toggl",
        subtitle = "Logs of How I Spent My Time Working on Projects",
        caption = "Made by Mingyang Li")+
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y")

ggsave("Plots/Waterfall_Projects.pdf", plot = last_plot())
