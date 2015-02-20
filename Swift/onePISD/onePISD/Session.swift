//
//  Session.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import Alamofire

/* TODO
	add storage mechanism for other fields
	error handling (no connection, wrong password, etc)
	rewrite.
*/

class Session {
	
	let url_login = "https://sso.portal.mypisd.net/cas/login?"
	let url_user = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	let url_grades = "https://parentviewer.pisd.edu/EP/PIV_Passthrough.aspx"
	let url_pinnacle = "https://gradebook.pisd.edu/Pinnacle/Gradebook/link.aspx?target=InternetViewer"
	
	let username: String
	let password: String
	
	let manager: Alamofire.Manager
	
	var grade_form: [String: String]?
	var pinnacle_form: [String: String]?
	
	var studentId: String? //Not used yet, but can be found in the first few logins.
	
	init(username: String, password: String) {
		self.username = username
		self.password = password
		
		self.manager = Alamofire.Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
	}
	
	func getSixWeekGrades(completionHandler: (NSHTTPURLResponse, NSString) -> ()) {
		login(completionHandler)
	}
	
	private func login(completionHandler: (NSHTTPURLResponse, NSString) -> ()) {
		println("Attempting login")
		
		self.manager.request(.GET, url_login).responseString { (_, response, string, _) in
			println(response)
			self.loginWithParams(string!, completionHandler: completionHandler)
		}
	}
	
	private func loginWithParams(html: String, completionHandler: (NSHTTPURLResponse, NSString) -> ()) {
		println("Sending login request with parameters")
		
		let lt = Parser.getLTfromHTML(html)
		
		let params = [
			"username" : self.username,
			"password" : self.password,
			"warn" : "false",
			"lt" : lt,
			"_eventId" : "submit",
			"reset" : "CLEAR",
			"submit": "LOGIN"
		]
		
		self.manager.request(.POST, url_login, parameters: params).responseString { (_, response, string, _) in
			
			//PARSE RESPONSE HERE TO CHECK FOR WRONG PASSWORD
			
			println(response)
			self.loadMainPage(completionHandler)
		}
	}
	
	private func loadMainPage(completionHandler: (NSHTTPURLResponse, NSString) -> ()) {
		println("Loading grade pages")
		
		self.manager.request(.GET, url_user).responseString { (_, response, html_data, _) in
			println(response)
			let url_redirect = Parser.getRedirectfromHTML(html_data!)
			self.grabGradeFormWithURL(url_redirect, completionHandler)
		}
	}
	
	private func grabGradeFormWithURL(url: String, completionHandler: (NSHTTPURLResponse, NSString) -> ()) {
		println("Grabbing gradebook form from \(url)")
		
		self.manager.request(.GET, url).responseString { (_, response, html_data, _) in
			println(response)
			self.grade_form = Parser.getGradeFormFromHTML(html_data!)
			self.submitGradeForm(completionHandler)
		}
	}
	
	private func submitGradeForm(completionHandler: (NSHTTPURLResponse, NSString) -> ()) {
		println("Submitting grade form")
		self.manager.request(.GET, url_grades, parameters: grade_form!).responseString { (_, response, html_data, _) in
			println(response)
			self.pinnacle_form = Parser.getPinnacleFormFromHTML(html_data!)
			self.loadMainGradePage(completionHandler)
		}
	}
	
	private func loadMainGradePage(completionHandler: (NSHTTPURLResponse, NSString) -> ()) {
		println("Loading main grade page")
		self.manager.request(.POST, url_pinnacle, parameters: pinnacle_form!).responseString { (_, response, html_data, _) in
			completionHandler(response!, html_data!)
		}
	}
}