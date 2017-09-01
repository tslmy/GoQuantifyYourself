# GoQuantifyYourself (Goquy)

![logo](logo/logo.png)

Goquy is a set of Python and R scripts that **visualizes your daily activities in waterfall-like timetables**. It shows you your past months (or years!) on a single image.

Goquy imports data from tracking apps such as [Moves][], [Qbserve][], [Toggl][], etc. Each functionality is contained in separated scripts, so you can take only what you need. :)  

This is a side-project by [tslmy][] while he is learning his way to [R][].

[tslmy]: https://github.com/tslmy/
[R]: https://www.r-project.org/

Sidenotes:

- *Goquy* is pronounced as "go-kway."
- Logo derivated from icons made by Freepik & Madebyoliver from [www.flaticon.com](https://www.flaticon.com/).

[TOC]

## Why This Project?

- Because I want to see how my time is spent. This retrospect helps me **optimizing my daily routine**/ lifestyle.
- Because **I have these data collected**. What a waste of time (and battery life) if you don't make use of these data?
- Because native visualization from these time-tracking apps are not quite getting there.

##What Can Goquy Do?

This is the timesheet built in [Qbserve][]:

![](https://ww4.sinaimg.cn/large/006tNc79gy1fj3k82fuqtj318s0v4do7.jpg)

It shows events for only two hours, and it contains many details I don't care about.

What I can do is a **waterfall-like timetable** that spans a whole year:

![](https://ww3.sinaimg.cn/large/006tNc79ly1fh7xyriyxnj31je172tkx.jpg)

- **Green**: productive activities, such as word processing, coding, etc.
- **Blue**: neutral activities, such as using Google, writing emails, etc.
- **Red**: Distractive activities, such as watching YouTube, reading Digg, etc.

By listing my daily performance side-by-side, I am able to recognize days when I grab every minute towards deadline, as well as days when I tend to lossen up a little bit. 

Besides a timetable, I'm also able to summarize how my productivities vary from day to day:

![](https://ww4.sinaimg.cn/large/006tNc79ly1fh7xxvq3nqj31jo17aq95.jpg)

Besides sitting in front of a computer, I also spend quite a lot of time everyday **commuting to university and walking around**. During vacation, some days I even don't touch my laptop at all. These offline activites can also be tracked by other apps, such as [Moves][].

Similar to [Qbserve][], [Moves][] also provides limited summaries for data it collected. 

![](https://ww3.sinaimg.cn/large/006tKfTcgy1fj4gef2bl5j30gv0ic437.jpg)

Fortunately, data from [Moves][] can also be exported and visualized by Goquy:

![](https://ws2.sinaimg.cn/large/006tKfTcly1fh4t8mq4pdj31kw188x6p.jpg)

The figure shown above is a record of my movements from mid June 2016 to early June 2017 (X-axis), with the Y-axis representing 24 hours in each day. Each color corresponds to a method of transportation.

This plot facilitated me recalling many events happened in the past year. You can read more about my experience here: [Visualizing Daily Activities with Moves](https://medium.com/@lmy/visualizing-daily-activities-with-moves-e65e62aab51).

Other than tracking activities with timetables, Goquy can also report other interesting data about you. For example, a [radar chart](http://www.datavizcatalogue.com/methods/radar_chart.html) that of your cinematic taste: 

![](https://ww3.sinaimg.cn/large/006tKfTcgy1fj4gr5qc78j30kc0etq47.jpg)

There are more to come from Goquy as I learn my way to the R language. Stay tuned. :)

## Installation

To start using **GoQuantifyYourself**, 

1. make sure you have these 2 applications installed:

- [Python3](https://www.python.org/downloads/), which is used to prepare data for RStudio.
- [RStudio](https://www.rstudio.com/products/rstudio/download/), which is for plotting.

2. Download (or `git clone`) this repo, [GoQuantifyYourself](https://github.com/tslmy/GoQuantifyYourself).
3. Inside this folder, open a terminal and install the required Python modules by executing `pip install -r requirements.txt`.
4. Everything stated below is assuming that you are working under the directory of **GoQuantifyYourself**.

## How To Visualize Time Spend on...

### … Sitting in Front of A Computer

I use [Qbserve][] to monitor my time spent on my Mac. 

#### How To

To make use of it, follow these steps:

1. Open the Qbserve main window.
2. As of version 1.63, go to ADVANCED > Export.
3. Under "ONE TIME EXPORT", specify "Totals and timesheet", "JSON" or "JSON min." and the day(s) that you want to plot. 
4. Hit "Export", and save the file to `QbserveExport/`. The filenames should look like: `2017-06-01_2017-06-02.json`.
5. Run `QbserveExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
6. Open `TimeTable for Computer Time.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

[Qbserve]: https://qotoqot.com/qbserve/

### … Working on Projects

Sometimes I track my work with [Toggl][]. It not only adds more detail to the "productivity hours" identified from [Qbserve][], but also corrects my off-screen-but-sitting-down tasks that are recorded by neither [Qbserve][] nor [Moves][].

[Toggl]: https://toggl.com/

#### Demo

![](https://ww1.sinaimg.cn/large/006tNc79ly1fh80p014m4j30zk0paq7s.jpg)

#### How To

1. Go to [the export page](https://toggl.com/app/reports/detailed/), and, using the _Export_ button, download reports as CSV files to the `TogglExport/` folder.
2. Run `TogglExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
3. Open `TimeTable for Working on Projects.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

### … Moving Around

The iOS/Android app [Moves][] tracks my activities. 

[Moves]: https://moves-app.com/


#### How To

1. Hit the big "[Download](https://accounts.moves-app.com/export/download)" button on [this Export Page](https://accounts.moves-app.com/export).
2. Unzip `moves_export.zip` and the `csv.zip` inside it.
3. Copy `moves_export/csv/full/storyline.csv` to `MovesExport/`.
4. Run `MovesExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
5. Open `TimeTable - Active Time.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

### ... Sleeping (or Trying to, at Least)

==*TODO*==

### What's My Taste Like in Movies?

 I label all my watched TV shows and movies with [trakt.tv](https://trakt.tv/).

####How To

1. Download your data by accessing `https://darekkay.com/service/trakt/trakt.php?username=USERNAME`. This service is provided by [Darek Kay](https://darekkay.com/2014/08/12/trakt-tv-backup/). Kudos.
2. Unzip the `trakt_backup_DATE-HERE.zip`, in which there is a `watched_movies.txt`.
3. Open this `watched_movies.txt`, copy its whole content, paste it onto [this JSON-to-CSV converter](https://konklone.io/json/), and __Download the entire CSV__ as `TraktExport/watched_movies.csv`.
4. Go to [API Settings of The Movie Database (TMDb)](https://www.themoviedb.org/settings/api) and apply for an App Key.
5. Save the 32-character v3 API Key in the format of `tmdb = "32-character v3 API Key here"` and save as `keys.py`.
6. Run `TraktExportToTables.py`, perhaps by `CMD+B`-ing within Sublime Text.
7. Open `Summary for Movies.r` in [RStudio][] and [source](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) this script.

## A Note for Developers

I used a virtualenv with Python3:

`virtualenv -p /usr/local/bin/python3 virtualenv`

so please remember to `source virtualenv/bin/activate` before starting to develop.

Also, remember to `pip freeze > requirements.txt` after installing/uninstalling Python packages.



[RStudio]: https://www.rstudio.com/