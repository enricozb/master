import csv

#The interest variable is the hashtag test you're looking for
#the name is what you want your output csv file to be
#This script will sweep through all hashtags and produce a .csv file with
#the following output:
##Row 1: hashtag text
##Row 2: date in YYYYMMDDHH format (24 hour clock EST)
##Row 3: Count of tweets using that hashtag in that hour

interest = 'mothersday'
name = 'sim'

with open('hash.csv','r') as csvin, open(name+'.csv', 'wb') as csvout:
    csvin = csv.reader(csvin, delimiter=',')
    csvout = csv.writer(csvout)
    count = 0
    lines_read = 0
    day_count = [0 for x in range(0,24)]
    all_together = {}
    for row in csvin:
        #print row
        lines_read +=1
        hashtag = row[1]
        if interest.lower() == hashtag.lower():
            date = row[0]
            count = int(row[2])
            all_together[date] = count        
        if lines_read % 1000000 == 0:
            print lines_read
    bb = all_together.keys()
    while len(bb) >0:
        current = min(bb)
        loc = bb.index(current)
        if int(current) < int(2009071700):
            csvout.writerow([interest,current,all_together[current]])
        bb.pop(loc)
    print lines_read
