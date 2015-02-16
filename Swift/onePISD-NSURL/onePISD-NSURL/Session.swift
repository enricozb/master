//
//  Session.swift
//  onePISD-NSURL
//
//  Created by Enrico Borba on 2/12/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Session {
	
	let username: String
	let password: String
	let session : NSURLSession
	let form : [String : String]
	
	
	init(username: String, password: String) {
		self.username = username
		self.password = password
		self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		form = [String : String]()
	}
	
	func submit() {
		
	}
	
	func setHeaders(params: [String : String]) {
		for (key, val) in params {
			session.configuration.HTTPAdditionalHeaders![key] = val;
		}
	}
	
}