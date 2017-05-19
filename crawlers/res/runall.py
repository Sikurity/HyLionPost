import json

with open('../crawler/settings.json') as data_file:
    data = json.load(data_file)

output = open('itercrawl.sh','w')

for k, v in data.items():
    output.write("python3 ../crawler/"+ v['file_name'] + " > " + k+".txt\n")

output.close()