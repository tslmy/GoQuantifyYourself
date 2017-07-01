import json, os

filename = "QbserveExport/2017-06-08_2017-06-09.json"
with open(filename, "r", encoding="utf-8") as fr:
    json_string = fr.read()
# parse the JSON data from the file:
parsed_json = json.loads(json_string)
# now get the table ready:

date = os.path.basename(filename)[:10]
# get total durations:
total_productive_duration = parsed_json["totals"]["productive_duration"]
total_neutral_duration = parsed_json["totals"]["neutral_duration"]
total_distracting_duration = parsed_json["totals"]["distracting_duration"]
total_away_duration = 86400-total_productive_duration-total_neutral_duration-total_distracting_duration

#add root:
lines = [
#"productive,"+str(total_productive_duration)+"\n",
#"neutral,"+str(total_neutral_duration)+"\n",
#"distracting,"+str(total_distracting_duration)+"\n",
"away,"+str(total_away_duration)+"\n"
]

# color_lines = [
#     "item, color",
#     "away, #FFFFFF",
#     "distracting, #FD7084",
#     "neutral, #34C3DB",
#     "productive, #A9EA5D"]

#what colors each productivity flag should be represented with:
productivity_to_color = {
    "away": "#FFFFFF",
    "distracting": "#FD7084",
    "neutral": "#34C3DB",
    "productive": "#A9EA5D"
}
productive_id_To_type = {
    -1: "distracting",
    0: "neutral",
    1: "productive",
    -2: "away"
}

categoryID_To_name = {}
categoryID_To_type = {}

for category in parsed_json["totals"]["category_top"]:
    #get the total duration of this category:
    category_duration = category["total_duration"]
    if category_duration>0:
        #get the type that this category belongs to:
        category_type = productive_id_To_type[category["productivity"]]
        #get the name of this category:
        category_name = category["name"].replace("-","_")
        #get the ID of this category:
        categoryID = category["id"]
        #register this category:
        categoryID_To_name[categoryID] = category_name
        categoryID_To_type[categoryID] = category_type
        #add this time for writing:
        #lines.append(category_type+"-"+category_name+","+str(category_duration)+"\n")
        #color = productivity_to_color[category_type]
        #color_lines.append(category_name+","+color)

for activity in parsed_json["totals"]["activity_top"]:
    categoryID = activity["category_id"]
    category_name = categoryID_To_name[categoryID]
    category_type = categoryID_To_type[categoryID]
    color = productivity_to_color[category_type]
    activity_duration = activity["total_duration"]
    activity_app = activity["app"].replace("-","_")
    activity_name = activity["name"].replace("-","_")
    if activity_app == activity_name:
        lines.append(category_type+"-"+category_name+"-"+activity_app+","+str(activity_duration)+"\n")
    else:
        lines.append(category_type+"-"+category_name+"-"+activity_app+"-"+activity_name+","+str(activity_duration)+"\n")
    #color_lines.append(activity_app+","+color)
    #color_lines.append(activity_name+","+color)

lines.sort(reverse=True)

with open("QbserveTables/"+date+".csv", "w+", encoding="utf-8") as f:
    f.writelines(lines)
#with open("QbserveTables/"+date+"_colors.csv", "w+", encoding="utf-8") as f:
#    f.write("\n".join(color_lines))