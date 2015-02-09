//
//  Session.swift
//  onePISD-Net
//
//  Created by Enrico Borba on 2/8/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Session {
	
	let url_login = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	
	let username: String
	let password: String
	let network: Net
	
	init (_ user: String, _ pass: String) {
		self.username = user
		self.password = pass
		self.network = Net(baseUrlString: url_login)
	}
	
	func login() {
		
		let params = [
			"username" : self.username,
			"password" : self.password,
		]
		
		network.POST(url_login, params: params, successHandler: { responseData in
			let result = responseData.json(error: nil)
			println("result \(result)")
			}, failureHandler: { error in
				NSLog("Error")
		})
		
	}
}