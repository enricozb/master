//
//  Session.swift
//  onePISD-NSURL
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Session {
	
	let url_login = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	
	let username: String
	let password: String
	var session: NSURLConnection?
	
	init(username: String, password: String) {
		self.username = username
		self.password = password
	}
	
	func init_session() {
		let request = NSMutableURLRequest(URL: NSURL(string: url_login)!)
		self.session = NSURLConnection(request: request, delegate: self, startImmediately: false)!
		self.session?.start()
		//self.session?.
	}
}