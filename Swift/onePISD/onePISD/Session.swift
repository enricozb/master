//
//  Session.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

/* TODO
	add storage mechanism for other fields
	error handling (no connection, wrong password, etc)
	rewrite.
*/

public struct MainSession {
	static let session: Session = Session()
}

enum SessionError {
	case wrongCredentials
}

class Session {
	
	let url_login = "https://sso.portal.mypisd.net/cas/login?"
	let url_user = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	let url_grades = "https://parentviewer.pisd.edu/EP/PIV_Passthrough.aspx"
	let url_pinnacle = "https://gradebook.pisd.edu/Pinnacle/Gradebook/link.aspx?target=InternetViewer"
	let url_gradesummary = "https://gradebook.pisd.edu/Pinnacle/Gradebook/InternetViewer/GradeSummary.aspx"
	
	var username: String
	var password: String
	
	let manager: Alamofire.Manager = Alamofire.Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
	
	var grade_form: [String: String]?
	var pinnacle_form: [String: String]?
	var grade_list: [Course]?
	
	var studentId: String? //Not used yet, but can be found in the first few logins.
	
	init(username: String, password: String) {
		self.username = username
		self.password = password
	}
	
	init() {
		self.username = ""
		self.password = ""
	}
	
	func setCredentials(#username: String, password: String) {
		self.username = username
		self.password = password
	}
	
	func getSixWeekGrades(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		login(completionHandler)
	}
	
	private func login(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Attempting Login")
		self.manager.request(.GET, url_login).responseString { (_, response, string, _) in
			self.loginWithParams(string!, completionHandler: completionHandler)
		}
	}
	
	private func loginWithParams(html: String, completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Setting Parameters")
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
		
		self.manager.request(.POST, url_login, parameters: params).responseString { (_, response, html_data, error) in
			
			//PARSE RESPONSE HERE; CHECK FOR WRONG PASSWORD (~11 elements = correct password, ~10 elements = incorrect password)
			//OR CHECK FOR nil on "Set-Cookie" in response
			
			View.showWaitOverlayWithText("Grabbing Cookies")
			let responseDict = response!.allHeaderFields as [String: String]
			
			if responseDict["Set-Cookie"] == nil {
				View.clearOverlays()
				completionHandler(response!, html_data!, SessionError.wrongCredentials)
			}
			else {
				self.loadMainPage(completionHandler)
			}
		}
	}
	
	private func loadMainPage(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Loading Gradebook")
		self.manager.request(.GET, url_user).responseString { (_, response, html_data, _) in
			let url_redirect = Parser.getRedirectfromHTML(html_data!)
			self.grabGradeFormWithURL(url_redirect, completionHandler)
		}
	}
	
	private func grabGradeFormWithURL(url: String, completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Grabbing Gradebook form")
		println("\tfrom url \(url)")
		self.manager.request(.GET, url).responseString { (_, response, html_data, _) in
			self.grade_form = Parser.getGradeFormFromHTML(html_data!)
			self.submitGradeForm(completionHandler)
		}
	}
	
	private func submitGradeForm(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Submitting Gradebook form")
		self.manager.request(.GET, url_grades, parameters: grade_form!).responseString { (_, response, html_data, _) in
			self.pinnacle_form = Parser.getPinnacleFormFromHTML(html_data!)
			self.loadMainGradePage(completionHandler)
		}
	}
	
	private func loadMainGradePage(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Loading Gradebook")
		self.manager.request(.POST, url_pinnacle, parameters: pinnacle_form!).responseString { (_, response, html_data, _) in
			self.setSemesterGrades(completionHandler)
		}
	}
	
	private func setSemesterGrades(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Grabbing Semester Grades")
		self.manager.request(.GET, url_gradesummary).responseString { (_, response, html_data, _) in
			let courses = Parser.getReportTableFromHTML(html_data!)
			
			self.grade_list = courses
			completionHandler(response!, html_data!, nil)
		}
	}
}