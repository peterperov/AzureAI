import pandas as pd
import re
import csv


file_name = "W:\GITHUB\AzureAI\langugages.xlsx"


# read by default 1st sheet of an excel file
# "ACRs SL5"
df = pd.read_excel(file_name, sheet_name = 0)

# print(df)
first_row = 0
current = ""
second = ""


xml_text = "<xml>\n"

for index, row in df.iterrows():
    first = row[0]

    if not pd.isnull(first) and first != "":
        current = row[0]
        second = row[1]

        # Generate XML node
        if first_row == 0: 
            first_row = 1
        else:
            xml_text +="</language>"

        xml_text += f"<language iso='{first}' name='{second}'>"

    third = row[2]
    # Print the generated XML node
    # print(xml_node)
    xml_text += f"<voice>{third}</voice>"

    print(current, second, row[2])


xml_text += "</xml>"