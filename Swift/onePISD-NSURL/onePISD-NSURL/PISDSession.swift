//
//  Session.swift
//  onePISD-NSURL
//
//  Created by Enrico Borba on 2/12/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class PISDSession {
	let url_login = "https://sso.portal.mypisd.net/cas/login?"
	
	let username: String
	let password: String
	let session: NSURLSession
	
	init(username: String, password: String) {
		self.username = username
		self.password = password
		self.session = NSURLSession.sharedSession()
	}
	
	func login() {
		let url = NSURL(string: self.url_login)!
		
		var login_load_responseHTML = ""
		var login_load_done = false
		
		let login_load_task = self.session.dataTaskWithURL(url) {(data, response, error) in
			login_load_responseHTML = NSString(data: data, encoding: NSUTF8StringEncoding)!
			login_load_done = true
		}
		
		login_load_task.resume()
		
		while(!login_load_done) {} //Totally asyncronous
		
		var lt = Parse.getLTfromHTML(login_load_responseHTML)
		
		let params = [
			"username" : self.username,
			"password" : self.password,
			"warn" : "false",
			"lt" : lt,
			"_eventId" : "submit",
			"reset" : "CLEAR",
			"submit": "LOGIN"
		]
		
		println(lt)
		
		let login_request = NSMutableURLRequest(URL: url)
		var err: NSError?
		
		login_request.HTTPMethod = "POST"
		login_request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)!
		
		
		/*/*
		let headers = [
			"Accept"			: "text/html,application/xhtml+xml,application/json;q=0.9,*/*;q=0.8",
			"Accept-Encoding"	: "gzip,deflate,sdch",
			"Accept-Language"	: "en-US,en;q=0.8,es;q=0.6",
			"Cache-Control"		: "max-age=0",
			"Connection"		: "keep-alive",
			"Content-Type"		: "application/x-www-form-urlencoded, application/json",
			"Host"				: "sso.portal.mypisd.net",
			"Origin"			: "https://sso.portal.mypisd.net",
			"Referer"			: "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
		]
		*/
		
		let headers = [
			"Content-Type" : "application/json; charset=utf-8"
		
		]
		
		for (header, val) in headers {
			login_request.setValue(val, forHTTPHeaderField: header)
		}
		
		var login_task = self.session.dataTaskWithRequest(login_request) { data, response, error -> Void in
			println(response)
			println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
		}
		
		login_task.resume()
	}
}

class Parse {
	
	class func getLTfromHTML(html: String) -> String {
		let range_start = html.rangeOfString("name=\"lt\" value=\"")
		let range_end = html.rangeOfString("name=\"_eventId\"")
		var index_end = range_end!.startIndex
		for i in 0...31 {
			index_end = index_end.predecessor()	//It's sad how bad swift actually is.
		}
		return html.substringWithRange(Range<String.Index>(start: range_start!.endIndex, end: index_end))
	}
}