//
//  Session.swift
//  onePISD
//
//  Created by Enrico Borba on 2/7/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import Alamofire

class Session {
	
	let url_login = "http://portal.mypisd.net/c/portal/login"
	
	let username: String
	let password: String
	let request : Alamofire.Manager
	
	init(user: String, pass: String) {
		self.username = user
		self.password = pass
		self.request = Alamofire.Manager.sharedInstance
	}
	
	func login() {
		let parameters = ["username" : self.username, "password" : self.password]
		
		Alamofire.request(.POST, url_login, parameters: parameters).responseString { (_, _, string, _) in
			println(string)
		}



	}
}