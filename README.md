# Where Has All My Time Gone?

This is a personal project for visualizing how my time is spent. 

[TOC]

## Time Spent Sitting in Front of A Computer

I use [Qbserve][] to monitor my time spent on my Mac. 

### Demo

![](https://ww4.sinaimg.cn/large/006tNc79ly1fh7xxvq3nqj31jo17aq95.jpg)

![](https://ww3.sinaimg.cn/large/006tNc79ly1fh7xyriyxnj31je172tkx.jpg)

### How To

To make use of it, follow these steps:

1. Open the Qbserve main window.
2. As of version 1.63, go to ADVANCED > Export.
3. Under "ONE TIME EXPORT", specify "Totals and timesheet", "JSON" or "JSON min." and the day(s) that you want to plot. 
4. Hit "Export", and save the file to `QbserveExport/`. The filenames should look like: `2017-06-01_2017-06-02.json`.
5. Run `QbserveExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
6. Open `TimeTable for Computer Time.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

[Qbserve]: https://qotoqot.com/qbserve/

## Time Spent Working on Projects

Sometimes I track my work with [Toggl](https://toggl.com/). It not only adds more detail to the "productivity hours" identified from [Qbserve][], but also corrects my off-screen-but-sitting-down tasks that are recorded by neither [Qbserve][] nor [Moves][].

### Demo

![](https://ww1.sinaimg.cn/large/006tNc79ly1fh80p014m4j30zk0paq7s.jpg)

### How To

1. Go to [the export page](https://toggl.com/app/reports/detailed/), and, using the _Export_ button, download reports as CSV files to the `TogglExport/` folder.
2. Run `TogglExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
3. Open `TimeTable for Working on Projects.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

## Time Spent Moving Around

The iOS/Android app [Moves][] tracks my activities. 

[Moves]: https://moves-app.com/

### Demo
![](https://ws2.sinaimg.cn/large/006tKfTcly1fh4t8mq4pdj31kw188x6p.jpg)

Okay... Here's an annotated copy:

![](https://ws1.sinaimg.cn/large/006tKfTcly1fh4t8hk9vhj31kw18a1l2.jpg)


### How To

1. Hit the big "[Download](https://accounts.moves-app.com/export/download)" button on [this Export Page](https://accounts.moves-app.com/export).
2. Unzip `moves_export.zip` and the `csv.zip` inside it.
3. Copy `moves_export/csv/full/storyline.csv` to `MovesExport/`.
4. Run `MovesExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
5. Open `TimeTable - Active Time.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

## Time Spent Sleeping (or Trying to, at Least)

==*TODO*==





[RStudio]: https://www.rstudio.com/