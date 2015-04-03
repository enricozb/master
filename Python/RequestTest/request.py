import requests
import json

params = {'username' : 'enricozb', 'password' : 'onferno77', 'buttonClick' : 'Display Decision' }

r = requests.post('https://decisions.mit.edu/decision.php', data = params)
print(r.text)