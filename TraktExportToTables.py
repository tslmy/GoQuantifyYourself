#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pprint import pprint as pp
import csv, json, os

#transpose = lambda a: [list(x) for x in zip(*a)]

jsonFileName = "TraktExport/watched_movies_data.json"
if not os.path.exists(jsonFileName):
    # Import a movie database api module:
    # I tried imdb-pie, but the connection was always reset by peer. That's why I hate pears.
    # Instead, I love apples. My iPhone works great.
    import tmdbsimple as tmdb
    # initialize this module:
    from keys import tmdb as key
    tmdb.API_KEY = key
    data = []
    with open(jsonFileName,"w+", encoding='utf-8') as fp:
        with open("TraktExport/watched_movies.csv","r", encoding='utf-8') as csvfile:
            # read this file as csv format:
            csvreader = csv.reader(csvfile) 
            # tell the iterable "csvreader" to skip the header:
            next(csvreader, None)
            # now actually read the file for the rows:
            for row in csvreader:
                _,_,movie_title,movie_year,_,_,_,movie_ids_tmdb = row # plays,last_watched_at,movie_title,movie_year,movie_ids_trakt,movie_ids_slug,movie_ids_imdb,movie_ids_tmdb
                movie = tmdb.Movies(movie_ids_tmdb)
                response = movie.info()
                print(movie.title)
                data.append(response)
                #print("======================",movie.title,"======================")
                #pp(response)
        json.dump(data, fp)
else:
    with open(jsonFileName,"r", encoding='utf-8') as data_file: 
        data = json.load(data_file)

if not data: # if this var is not successfully loaded or created:
    raise ValueError
# process data:
# count genres for all movies:
genresCounter = {}
for movie in data:
    for genres in movie["genres"]:
        genre = genres["name"]
        if genre in genresCounter:
            genresCounter[genre] += 1
        else:
            genresCounter[genre]  = 1
pp(genresCounter)
# write to genre counter file:
with open('TraktTables/genres.csv', 'w') as f:
    #f.write("Genre, Count\n")
    #for i in genresCounter:
    #    f.write(i+", "+str(genresCounter[i])+"\n")
    f.write(", ".join(genresCounter.keys())+"\n")
    f.write(", ".join([str(max(genresCounter.values()))]*len(genresCounter))+"\n")
    f.write(", ".join(["0"]*len(genresCounter))+"\n")
    f.write(", ".join([str(i) for i in genresCounter.values()]))