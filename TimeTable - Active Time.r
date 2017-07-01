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
data_log <- read_csv("/Volumes/lmy/Projects/TimeManagement/MovesTables/storyline.csv", 
                      col_types = cols(date = col_date(format = "%Y-%m-%d"), 
                                        end = col_time(format = "%H:%M:%S"), 
                                      start = col_time(format = "%H:%M:%S")))

#    Mark all entries in grey first:
data_log$color <- rep("white",nrow(data_log)) # make new column 
#    Define the palatte:
# palatte <- list(walking = "#38D857",   #green
#                 cycling = "#3BCBFF",   #cyan
#                 running = "#F051F5",   #magnet
#                 airplane = "#C87FFF",  #purple
#                 transport = "#F8766D") #orange

data_log$color[data_log$name == "walking"] <- "#38D857"
data_log$color[data_log$name == "cycling"] <- "#3BCBFF"
data_log$color[data_log$name == "running"] <- "#F051F5"
data_log$color[data_log$name == "airplane"] <- "#C87FFF"
data_log$color[data_log$name == "transport"] <- "#F8766D"


ggplot(data = data_log, aes(x = date, y = duration)) + 
  geom_bar(stat = "identity", fill=data_log$color) + 
  # now remove background elements -- from http://felixfan.github.io/ggplot2-remove-grid-background-margin/:
  theme(panel.grid.major = element_blank(), # no major gridlines
        panel.grid.minor = element_blank(), # no minor gridlines
        panel.background = element_blank() # no background
        #axis.title = element_blank(), # no axis labels
        #axis.line = element_blank() # no axis lines # = element_line(colour = "black")
        )+
  scale_y_reverse(breaks=0:24)+#function(x) seconds_to_period(x))#strftime(chron(times=c(x/86400)), "%H:%M"))#+coord_flip()
  coord_cartesian(ylim = c(0, 24), expand = FALSE)+
  labs( x = "Date", y = "Time (Hour)",
        title ="Data Exported from Moves",
        subtitle = "Logs of How I Spent My Time Moving Around",
        caption = "Made by Mingyang Li")+
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") +

ggsave("Plots/Waterfall_Moves.pdf", plot = last_plot())
