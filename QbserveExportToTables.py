# -*- coding: utf-8 -*-

import glob, os, json#, datetime

#what colors each productivity flag should be represented with:
productivity_id_to_color = {
    -2: "#FFFFFF",
    -1: "#FD7084",
    0: "#34C3DB",
    1: "#A9EA5D"
}
productivity_id_to_type = {
  -2: "away",
  -1: "distracting",
  0: "neutral",
  1: "productive"
}

#secondsToString = lambda seconds: datetime.datetime.fromtimestamp(seconds-28800).strftime('%H:%M:%S') #28800 to shift the "morning 8 o'clock" out.
secondsToHourString = lambda seconds: str(seconds/3600)

#date_regex = '[0-9]{4}-(((0[13578]|(10|12))-(0[1-9]|[1-2][0-9]|3[0-1]))|(02-(0[1-9]|[1-2][0-9]))|((0[469]|11)-(0[1-9]|[1-2][0-9]|30)))'
with open("QbserveTables/log.csv","w+", encoding='utf-8') as fl:
    fl.write("date,relative_start_time,duration,relative_end_time,activity_id,activity_appId,category_id,productivity_id,type,color,category_name,activity_title\n")
    with open("QbserveTables/totals.csv","w+", encoding='utf-8') as ft:
        ft.write("date,type,duration\n")#,day_length\n")
        for filename in glob.glob("QbserveExport/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].json"):#(date_regex+"_"+date_regex+".json"):
            print("Processing "+filename+" ...")
            # open and read the file:
            with open(filename, "r", encoding='utf-8') as fr:
                json_string = fr.read()
            # parse the JSON data from the file:
            parsed_json = json.loads(json_string)
            # now get the table ready:
            date = filename[14:24]
            #with open("QbserveTables/"+filename[14:24]+".csv","w+", encoding='utf-8') as f:
            day_start_time = parsed_json["info"]["start_time"]
            #day_end_time = parsed_json["info"]["end_time"]
            # ========================== write totals.csv ================================
            distracting_duration = parsed_json["totals"]["distracting_duration"]
            neutral_duration = parsed_json["totals"]["neutral_duration"]
            productive_duration = parsed_json["totals"]["productive_duration"]
            #day_length = 86399#day_length = day_end_time - day_start_time # this is always 23:59:59
            #away_duration = day_length-distracting_duration-neutral_duration-productive_duration
            ft.write(date+",productive,"+secondsToHourString(productive_duration)+"\n")
            ft.write(date+",neutral,"+secondsToHourString(neutral_duration)+"\n")
            ft.write(date+",distracting,"+secondsToHourString(distracting_duration)+"\n")
            #ft.write(date+",away,"+str(away_duration)+","+productivity_id_to_color[-2]+"\n")
            # ============================ write log.csv ================================
            #use the timepoint when monitoring has started as the last end time of events at the beginning:
            last_end_time = day_start_time
            #iterate over all recorded events:
            for event in parsed_json["history"]["log"]:
                absolute_start_time = event["start_time"]
                relative_start_time = absolute_start_time-day_start_time
                if absolute_start_time > last_end_time: # if there's idleness not recorded:
                    idle_relative_start_time = last_end_time-day_start_time
                    idle_relative_end_time   = relative_start_time # the relative_start_time of the event is the relative_end_time of the idleness
                    idle_duration = idle_relative_end_time-idle_relative_start_time
                    color = productivity_id_to_color[-2]
                    fl.write(date+","+secondsToHourString(idle_relative_start_time)+","+
                          secondsToHourString(idle_duration)+","+
                          secondsToHourString(idle_relative_end_time)+",-1,-1,-1,-2,away,#FFFFFF,idle,idle\n")
                duration = event["duration"]
                relative_end_time = relative_start_time+duration
                activity_id = event["activity_id"]
                #read from the activity_data:
                activity_data = parsed_json["history"]["activities"][str(activity_id)]
                activity_appId = activity_data["app_id"]
                category_id = activity_data["category_id"]
                activity_title = activity_data["title"]
                #read from the category_data:
                category_data = parsed_json["history"]["categories"][str(category_id)]
                category_name = category_data["name"]
                productivity_id = category_data["productivity"]
                #color = productivity_id_to_color[productivity_id]
                fl.write(date+","+secondsToHourString(relative_start_time)+","+
                      secondsToHourString(duration)+","+
                      secondsToHourString(relative_end_time)+","+
                      str(activity_id)+","+
                      str(activity_appId)+","+
                      str(category_id)+","+
                      str(productivity_id)+","+
                      productivity_id_to_type[productivity_id]+","+
                      productivity_id_to_color[productivity_id]+","+
                      category_name+","+
                      activity_title+"\n")
                last_end_time = absolute_start_time + duration #update last_end_time cursor to the end of this event

#last-day data:
with open("QbserveTables/lastDay.csv","w+", encoding='utf-8') as fl:
    fl.write("date,type,color,category_name,app,duration\n")
    for activity in parsed_json["totals"]["activity_top"]:
        app_name = activity["app"]
        app_duration = activity["total_duration"]
        category_id = activity["category_id"]
        category = parsed_json["history"]["categories"][str(category_id)]
        category_name = category["name"]
        productivity_id = category["productivity"]
        color = productivity_id_to_color[productivity_id]
        productivity_type = productivity_id_to_type[productivity_id]
        fl.write(date+","+productivity_type+","+color+","+category_name+","+app_name+","+secondsToHourString(app_duration)+"\n")














