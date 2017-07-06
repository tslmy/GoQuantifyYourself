#! /usr/bin/env python3
# -*- coding: utf-8 -*-
import csv
from datetime import datetime, time

# define the filenames, just for code readabiliy matters:
filename_to_read  = "MovesExport/storyline.csv"
filename_to_write = "MovesTables/storyline.csv"

def write_activity(start_obj, end_obj, name = "place"):
    start_day = start_obj.day
    end_day = end_obj.day
    if end_day is not start_day:
        start_obj_ending = start_obj.replace(hour = 23, minute = 59, second = 59)
        end_obj_beginning = end_obj.replace(hour = 0, minute = 0, second = 0)
        #print("Detected. Spliting.")
        write_activity(start_obj, start_obj_ending, name)
        write_activity(end_obj_beginning, end_obj, name)
    else:
        date_str = start_obj.strftime('%Y-%m-%d')
        start_str = start_obj.strftime('%H:%M:%S')
        end_str = end_obj.strftime('%H:%M:%S')
        duration_obj = end_obj-start_obj # this will be a 'datetime.timedelta' object 
        duration = duration_obj.total_seconds()/3600
        if duration>0:
            #print(date_str+"\t"+start_str+"\t"+end_str+"\t"+name)
            writer.writerow([date_str, start_str, end_str, name])

# open the file to read:
with open(filename_to_read, 'r', encoding='utf-8') as csvfile:# If csvfile is a file object, it should be opened with newline=''.
    # read this file as csv format:
    csvreader = csv.reader(csvfile) 
    # tell the iterable "csvreader" to skip the header:
    next(csvreader, None)
    # make a shorthand for the beginning time of every day:
    #beginning_of_the_day = datetime(1900,1,1) #the default time params are 00:00:00.
    with open("MovesTables/storyline.csv","w+", encoding='utf-8') as fl:
        writer = csv.writer(fl)
        # write the header:
        writer.writerow(["date", "start", "end", "name"])
        for row in csvreader:
            # save each entry to a easy-to-remember variable name:
            this_date_raw, this_type_raw, this_name_raw, this_start_raw, this_end_raw, _ = row
            if this_type_raw!="place":
                # parse the dates and durations:
                this_date_obj = datetime.strptime(this_date_raw, '%m/%d/%y')
                this_start_obj = datetime.strptime(this_start_raw.replace(":",""), '%Y-%m-%dT%H%M%S%z')
                this_end_obj = datetime.strptime(this_end_raw.replace(":",""), '%Y-%m-%dT%H%M%S%z')
                # now we write this activity:
                write_activity(this_start_obj, this_end_obj, this_name_raw)
