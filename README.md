# Where Has All My Time Gone?

This is a personal project for visualizing how my time is spent. 

[TOC]

## Time Spent Sitting in Front of A Computer

I use [Qbserve](https://qotoqot.com/qbserve/) to monitor my time spent on my Mac. To make use of it, follow these steps:

1. Open the Qbserve main window.
2. As of version 1.63, go to ADVANCED > Export.
3. Under "ONE TIME EXPORT", specify "Totals and timesheet", "JSON" or "JSON min." and the day(s) that you want to plot. 
4. Hit "Export", and save the file to `QbserveExport/`. The filenames should look like: `2017-06-01_2017-06-02.json`.
5. Run `QbserveExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
6. Open `TimeTable for Computer Time.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

## Time Spent Moving Around

The iOS/Android app [Moves](https://moves-app.com/) tracks my activities. 

### Demo



### How To

1. Hit the big "[Download](https://accounts.moves-app.com/export/download)" button on [this Export Page](https://accounts.moves-app.com/export).
2. Unzip `moves_export.zip` and the `csv.zip` inside it.
3. Copy `moves_export/csv/full/storyline.csv` to `MovesExport/`.
4. Run `MovesExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
5. Open `TimeTable - Active Time.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

## Time Spent Sleeping (or Trying to, at Least)

*TODO*





[RStudio]: https://www.rstudio.com/