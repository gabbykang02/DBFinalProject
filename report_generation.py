import os
import pymysql
import pandas as pd

# Initialize helper methods

# Print in table format
def printTable(result, colList=None):
    # https://stackoverflow.com/questions/17330139/python-printing-a-dictionary-as-a-horizontal-table-with-headers
   colList = list(result[0].keys() if result else [])
   temp = [colList] # 1st row = header
   for item in result:
       temp.append([str(item[col] if item[col] is not None else '') for col in colList])
   colSize = [max(map(len,col)) for col in zip(*temp)]
   formatStr = ' | '.join(["{{:<{}}}".format(i) for i in colSize])
   temp.insert(1, ['-' * i for i in colSize]) # Seperating line
   for item in temp:
       print(formatStr.format(*item))

# Print available methods
def printMethods():
    print("Use \'q\' or \'quit\' to quit.")
    print("GetMaxCovid(country VARCHAR(100)) takes in a country name and returns the max number of cases and what month/year they occured for that country.")
    print("GetAverageRatings(year INT) takes in a year and returns the average rating for film media released in that year.")
    print("GetCovidPlatforms(year INT, month INT) takes in month/year and returns the average Metacritic rating for games relased in that month.")
    print("GetStatCumulative(country VARCHAR(100), startMonth INT, startYear INT, stopMonth INT, stopYear INT) takes in a time period (specified by start/stop month/year and a country, plotting COVID cases and twitch stats overtime. The graph display is not compatible with the python script, but is compatible with ipynb")
    print("GetCovidTwitchStats(command VARCHAR(15)) takes in twitchStatistcs and returns the specified twitch statistics over available time.\nPossible commands: hoursWatched, avgViewers, peakViewers, avgChannels, peakChannels, hoursStreamed, gamesStreamed, activeAffiliate, activePartners")
# Initialize database and cursors
db = pymysql.connect(
    host = "dbase.cs.jhu.edu",
    user = "22fa_gkang9",
    password = "o8sVqdtzqE",
    database = "22fa_gkang9_db")
cursor = db.cursor(pymysql.cursors.DictCursor)


# Call methods
print("Use \'q\' or \'quit\' to quit. Use \'h\' or \'help\' for info on methods")
method_name = input("Enter method name: ")
method_name = method_name.lower()
while (method_name != "q"):
    if (method_name == "getmaxcovid"):
        country = input("Enter country name: ")
        cursor.execute("CALL GetMaxCovid(%s)", country)
        results = cursor.fetchall()
        printTable(results)
    elif (method_name == "getaverageratings"):
        year = input("Enter desired year: ")
        cursor.execute("CALL GetAverageRatings(%s)", int(year))
        results = cursor.fetchall()
        printTable(results)
    elif (method_name == "getcovidplatforms"):
        year = input("Enter desired year: ")
        month = input("Enter desired mont: ")
        cursor.execute("CALL GetCovidPlatforms(%s, %s)", [year, month])
        printTable(results)
    elif (method_name == "help" || method_name == "h"):
        printMethods()
    else:
        print("ERROR: Invalid Command")
    method_name = input("Enter procedure name: ")

db.commit()
cursor.close()
db.close()
        
