# -*- coding: utf-8 -*-
"""
Created on Tue Mar 22 10:07:02 2016

@author: nrobinson
"""
from bs4 import BeautifulSoup
from lxml import html
import requests
import pandas as pd
import re
import numpy as np

url = 'http://wdfw.wa.gov/fishing/creel/puget/2000/mar20-26-2000/peninsula.htm'

response = requests.get(url)
html = response.content

#Get html and then select only the tables
soup = BeautifulSoup(html,'lxml')
table = soup.find("table")
#print table.prettify()

#Explore data to find out the location of the info we need
for i in range(40,450):  #len(table.findAll('tr')[1:])):
    print i; print table.findAll('tr')[1:][i]
    #Column headers = table.findAll('tr')[1:][3]
    #T1 = table.findAll('tr')[1:][1/4/5]
    #T2 = table.findAll('tr')[1:][8/11/12]
    #T3 = table.findAll('tr')[1:][15/18/19]
    #T4 = table.findAll('tr')[1:][22/25/26]  
    #T5 = table.findAll('tr')[1:][29/32/33]   
    #T6 = table.findAll('tr')[1:][36/39/40]
    #T7 = table.findAll('tr')[1:][43/46/47]

###############################################################################
#For table setup:

#                       # Boats       #Anglers       Chinook    .....
#  ------------------------------------------------------------------
#  Port 1    Private
#  Date 1    Ave. Wt.
#  ------------------------------------------------------------------
#  Port 2    Private
#  Date 2    Ave. Wt.
#  ------------------------------------------------------------------
##############################################################################
#Use info from the 1st number for each table to get port and date. This will go in the 1st col
ports = []; dates = []
for i in range(1,46,7):
    ports.append(str(table.findAll('tr')[1:][i]).split('colspan=')[1].split('<')[0])
    dates.append(str(table.findAll('tr')[1:][i]).split('x:num=')[1].split('<')[0])

#Clean up lists
ports = [re.sub('^"[0-9]">', '', x) for x in ports]
dates = [re.sub('^"[0-9]{5}">', '', x) for x in dates]
    
###############################################################################
#Get header row
cols = str(table.findAll('tr')[1:][3]).split('\n<td'); cols = cols[2:]
cols = [x.split('>')[1].split('</td')[0] for x in cols]
cols[-1] = 'NUMBER_' + cols[-1]; cols[-2] = 'SPECIES_' + cols[-2]
cols[0] = 'NUMBER_'+cols[0]; cols[1] = 'NUMBER_'+cols[1]

#Add first two column names for correct table
cols.insert(0,'MEASURE');cols.insert(0,'PORT_DATE')

###############################################################################
#Get data
privData =[]
for pRng in range(4,48,7):
    priv = str(table.findAll('tr')[1:][pRng]).split('\n<td')
    priv = priv[2:]
    priv = [x.split('>')[1].split('</td')[0] for x in priv]; priv.insert(0,'Private')
    privData.append(priv)

avgWtData = []
for awRng in range(5,49,7):    
    avgWt = str(table.findAll('tr')[1:][awRng]).split('\n<td')
    avgWt= avgWt[2:]
    avgWt = [x.split('>')[1].split('</td')[0] for x in avgWt]
    avgWt = [repr(x).replace("\\","")[1:-1] for x in avgWt]
    avgWt = [re.sub('xc2xa', '', x) for x in avgWt]; avgWt.insert(0,'Avg. Wt')
    avgWtData.append(avgWt)

#Compile data into array
for i in range(0,len(ports)):
    row1 = [ports[i]] + privData[i]
    row2 = [dates[i]] + avgWtData[i]        
    if i == 0:
        ar = np.array([row1,row2])
    else:
        ar = np.vstack([ar,[row1,row2]])

###############################################################################
#Create and write table
df = pd.DataFrame(data=ar,index=range(0,ar.shape[1]), columns=cols)
df.to_csv('C:/Users/nrobinson/Desktop/dataForKatie.csv',index=False)