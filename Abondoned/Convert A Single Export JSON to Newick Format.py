import json
#source activate /Users/lmy/anaconda/envs/GerneralPurposePython36
#conda install -c etetoolkit ete3 -y
from ete3 import Tree

filename = "QbserveExport/2017-06-08_2017-06-09.json"
with open(filename, "r", encoding="utf-8") as fr:
    json_string = fr.read()
# parse the JSON data from the file:
parsed_json = json.loads(json_string)
# now get the table ready:
date = filename[14:24]
# get total durations:
total_productive_duration = parsed_json["totals"]["productive_duration"]
total_neutral_duration = parsed_json["totals"]["neutral_duration"]
total_distracting_duration = parsed_json["totals"]["distracting_duration"]
total_away_duration = 86400-total_productive_duration-total_neutral_duration-total_distracting_duration

#add root:
Troot = Tree(name="root")
#first-level children:
Tproductive = Troot.add_child(name="productive", support=total_productive_duration/86400)
Tneutral = Troot.add_child(name="neutral", support=total_neutral_duration/86400)
Tdistracting = Troot.add_child(name="distracting", support=total_distracting_duration/86400)
Taway = Troot.add_child(name="away", support=total_away_duration/86400)

productive_id_To_Tnode = {
    -1: Tdistracting,
    0: Tneutral,
    1: Tproductive,
    -2: Taway
}

categoryID_To_Node = {}

for category in parsed_json["totals"]["category_top"]:
    #get the tree node of the type that this category belongs to:
    Ttype = productive_id_To_Tnode[category["productivity"]]
    #create a tree node for this category:
    Tcategory = Ttype.add_child(name=category["name"], support=category["total_duration"]/86400)
    #add this category node to the dict:
    categoryID_To_Node[category["id"]] = Tcategory

for activity in parsed_json["totals"]["activity_top"]:
    #get the tree node of the category that this activity belongs to:
    Tcategory = categoryID_To_Node[activity["category_id"]]
    #create a tree node for this activity:
    Tactivity = Tcategory.add_child(name=activity["app"], support=activity["total_duration"]/86400)

Troot.write(format=2, outfile="QbserveTables/"+date+".nw")

