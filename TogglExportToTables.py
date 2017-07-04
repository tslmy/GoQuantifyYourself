# -*- coding: utf-8 -*-

import glob, os, json, csv#, datetime
from datetime import datetime, time

if_verbose = False
# define the filenames, just for code readability matters:
filename_to_write = "TogglTables/data.csv"


def write_activity(start_obj, end_obj, name = "idle"):
    '''This function writes a time entry to the opened csv file.'''
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
            duration_str = str(duration)
            if if_verbose: print(date_str+"\t"+start_str+"\t"+end_str+"\t"+name+"\t"+duration_str+"\t")
            writer.writerow([date_str, start_str, end_str, name, duration_str])

# Open the file for writing first:
with open(filename_to_write,"w+", encoding='utf-8') as fl:
    writer = csv.writer(fl)
    # write the header:
    writer.writerow(["date", "start", "end", "name", "duration"])
    # before iterating over the csv table, set a flag:
    this_is_the_first_entry = True
    # Find files to read:
    for filename_to_read in glob.glob("TogglExport/Toggl_time_entries_[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_to_[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].csv"):
        print("Processing "+filename_to_read+" ...")
        # open the file to read:
        with open(filename_to_read, 'r', encoding='utf-8') as csvfile:# If csvfile is a file object, it should be opened with newline=''.
            # read this file as csv format:
            csvreader = csv.reader(csvfile) 
            # tell the iterable "csvreader" to skip the header:
            next(csvreader, None)
            # now actually read the file for the rows:
            for row in csvreader:
                # save each entry to a easy-to-remember variable name:
                #User, Email, Client, Project, Task, Description, Billable, Start_date, Start_time, End_date, End_time, Duration, Tags, Amount = row
                _,_,_,Project,_,Description,_,Start_date, Start_time, End_date, End_time,_,_,_  = row
                # combine raw strings of date&time:
                Start = Start_date+" "+Start_time
                End = End_date+" "+End_time
                # debug info:
                if if_verbose: print(Project+" - "+Description+"\t\t\t"+Start+" - "+End)
                # parse the dates and durations:
                this_start_obj = datetime.strptime(Start, '%Y-%m-%d %H:%M:%S')
                this_end_obj = datetime.strptime(End, '%Y-%m-%d %H:%M:%S')
                # some shorthands:
                this_start_day = this_start_obj.date()
                this_start_time = this_start_obj.time()
                # now the real work:
                if this_is_the_first_entry:
                    # disable this toggle:
                    this_is_the_first_entry = False
                    # update the "now" pointer:
                    now = this_start_obj
                    # create a shorthand:
                    now_time = now.time()
                    # navigate to the beginning of this day:
                    the_beginning = now.replace(hour = 0, minute = 0, second = 0)
                    # it is possible that our first activity started at a new day:
                    if now_time is not the_beginning:
                        write_activity(the_beginning, now)
                # if this activity begins later than the current moment we tracked to:
                if this_start_obj > now:
                    if Project == "idle":
                        this_start_obj=now
                    else:
                        # then we have to compensate for the empty record:
                        #print("Compensating...")
                        write_activity(now, this_start_obj)
                        # and update the current-moment pointer:
                        now = this_start_obj
                # now we write this activity:
                if Project == "idle":
                    write_activity(this_start_obj, this_end_obj, "idle")
                else:
                    write_activity(this_start_obj, this_end_obj, Project+" - "+Description)
                # and update the current-moment pointer:
                now = this_end_obj

