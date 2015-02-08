//
//  Session.swift
//  onePISD-Pythonic
//
//  Created by Enrico Borba on 2/8/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Session {
	
	let url_login: String = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	
	let username: String
	let password: String
	let session: HttpSession
	var headers: [String: String]
	
	init(username: String, password: String) {
		self.username = username
		self.password = password
		self.session = requests.Session()
		self.headers = [String:String]()
	}
	
	func init_headers() {
		self.headers = [
			"Accept"			: "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
			"Accept-Encoding"	: "gzip,deflate,sdch",
			"Accept-Language"	: "en-US,en;q=0.8,es;q=0.6",
			"Cache-Control"		: "max-age=0",
			"Connection"		: "keep-alive",
			//"Content-Type"		: "application/x-www-form-urlencoded",
			"Host"				: "sso.portal.mypisd.net",
			"Origin"			: "https://sso.portal.mypisd.net",
			"Referer"			:"https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
		]
	}
	
	func login() {
		let html = session.get(url_login, headers: self.headers, timeout: 5).text!
		println(Parser.getlt(html))
		let params = [
			"username" : self.username,
			"password" : self.password,
			"warn" : "true",
			"lt" : Parser.getlt(html),
			"_eventId" : "submit",
			"reset" : "CLEAR",
			"submit": "LOGIN"
		]
		var resp = session.post(self.url_login, params, headers: self.headers, timeout: 5)
		println(resp.response!)
		println(resp.text!)
	}
}