import mechanize
import urllib2
import urllib
import cookielib
from time import sleep

class PISD_Session:

	url_pisdlogin = 'https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin'
	url_gradebooklogin = 'https://gradebook.pisd.edu/Pinnacle/Gradebook/Logon.aspx'
	url_gradesummary = 'https://gradebook.pisd.edu/Pinnacle/Gradebook/InternetViewer/GradeSummary.aspx#'

	def __init__(self, username, password, verbose = False):
		self.username = username
		self.password = password
		self.verbose = verbose
		self.create_browser()

	def create_browser(self):
		self.br = mechanize.Browser()
		self.cj = cookielib.LWPCookieJar()
		self.cj.clear()
		self.br.set_cookiejar(self.cj)

		self.br.set_handle_equiv(True)
		self.br.set_handle_redirect(True)
		self.br.set_handle_referer(True)
		self.br.set_handle_robots(False)
		self.br.set_handle_redirect(mechanize.HTTPRedirectHandler)
		self.br.addheaders = [('User-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.94 Safari/537.36')]

	def login(self):
		self.ssologin()
		self.gradeview = self.gradeviewlogin()

	def ssologin(self):
		if(self.verbose): print('Attempting sso login...')
		for i in range(1,6):
			try:
				self.try_ssologin()
				if(self.verbose): print('\tsso login successful!')
				break
			except:
				if(self.verbose): print('\tAttempt %d Connection reset by peer. Trying again in 5 seconds...' %i)
				#sleep(5)

	def try_ssologin(self):
		if(self.verbose): print('\tOpening PISD login page...')
		self.br.open(self.url_pisdlogin)
		
		if(self.verbose): print('\tSetting form values...')
		self.br.select_form(nr = 0)
		self.br.form['username'] = self.username
		self.br.form['password'] = self.password
		
		if(self.verbose): print('\tSubmitting sso form...')
		self.br.submit()
		
		if(self.verbose): print('\tGrabbing uID...')
		self.br.select_form('enter')
		self.uID = self.br.form['uID']
		if(self.verbose): print('\tSuccessfully logged into myPISD!')

	def gradeviewlogin(self):
		if(self.verbose): print('Attempting gradeview login...')
		
		url_encoded = self.url_parentviewer_encode(self.uID)
		self.br.open(url_encoded)

		self.br.select_form(nr = 0)

		if(self.verbose): print('\tGrabbing gradeview credientials...')
		temp_user = self.br.form['userId']
		temp_pass = self.br.form['password']
		
		if(self.verbose): print('\tOpening gradebook...')
		self.br.open(self.url_gradebooklogin)

		if(self.verbose): print('\tSetting gradebook form values...')
		self.br.select_form(nr = 0)
		self.br.form['ctl00$ContentPlaceHolder$Username'] = temp_user
		self.br.form['ctl00$ContentPlaceHolder$Password'] = temp_pass

		if(self.verbose): print('\tSubmitting gradeview login form')
		r = self.br.submit()

		if(self.verbose): print('\tSuccessfully logged into Gradeview!')
		return r

	def url_parentviewer_encode(self, uID):
		return 'https://parentviewer.pisd.edu/EP/PIV_Passthrough.aspx?action=trans&uT=S&uID=' + uID + '&submit=Login+to+Parent+Viewer'

	def goto_gradesummary(self) :
		r = self.br.open(self.url_gradesummary)
		s = r.read()
		print(s[s.index("<table class='reportTable'>") : s.index('</tbody></table>')])

session = PISD_Session('enrico.borba.1','inferno&7', True)
session.login()
session.goto_gradesummary()