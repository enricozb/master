//
//  Browser.swift
//  onePISD-NSURL
//
//  Created by Enrico Borba on 2/13/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Browser {
	
	private let session : NSURLSession
	private let request : NSMutableURLRequest
	private var err		: NSError?
	
	init(url : String) {
		self.session = NSURLSession.sharedSession()
		self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
	}
	
	func add_headers(params : [String : String]) {
		for (header, val) in params {
			self.request.addValue(val, forHTTPHeaderField: header)
		}
	}
	
	func set_method(method : String) {
		self.request.HTTPMethod = method
	}
	
	func set_params(params: [String: String]) {
		self.request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
	}
	
	func submit() {
		let task = self.session.dataTaskWithRequest(self.request)
		task.resume()
		println(task.response)
	}
}