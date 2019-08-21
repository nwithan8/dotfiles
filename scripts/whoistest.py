#!/usr/bin/python
# Check creation date, update date and expiration date of a domain using WHOIS

try:
	import pythonwhois
except ImportError:
	from pip._internal import main as pip
	print("Gathering necessary package: pythonwhois")
	pip(['install', 'pythonwhois'])
	import pythonwhois
from datetime import datetime
import sys

def isExpired(x_date):
    return (datetime.now() > x_date[0])

if len(sys.argv) > 1:
	w = pythonwhois.get_whois(sys.argv[1])
	print("Creation date: " + w['updated_date'][0].strftime("%b %d, %Y"))
	print("Updated date: " + w['updated_date'][0].strftime("%b %d, %Y"))
	print("Expiration date: " + w['expiration_date'][0].strftime("%b %d, %Y"))

	if isExpired(w['expiration_date']):
    		print("DOMAIN IS EXPIRED.")
	else:
    		print("Not expired.")
else:
	print("Please indicate a domain.\nUsage: " + sys.argv[0] + " DOMAIN")
