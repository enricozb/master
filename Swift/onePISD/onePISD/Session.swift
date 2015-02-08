import Foundation
import Alamofire

class Session {
	
	let url_login = "https://sso.portal.mypisd.net/cas/login"
	let url_user = "http://portal.mypisd.net/user/"
	
	let username: String
	let password: String
	let sessionManager: Alamofire.Manager
	let cookies : NSHTTPCookieStorage
	var last_Request : Request?
	init(username: String, password: String) {
		self.username = username
		self.password = password
		
		var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
		defaultHeaders["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
		defaultHeaders["Accept-Encoding"] = "gzip,deflate,sdch"
		defaultHeaders["Accept-Language"] = "en-US,en;q=0.8,es;q=0.6"
		defaultHeaders["Cache-Control"] = "max-age=0"
		defaultHeaders["Connection"] = "keep-alive"
		defaultHeaders["Content-Type"] = "application/x-www-form-urlencoded"
		defaultHeaders["Host"] = "sso.portal.mypisd.net"
		defaultHeaders["Origin"] = "https://sso.portal.mypisd.net"
		defaultHeaders["Referer"] = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
		
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		self.cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
		configuration.HTTPCookieStorage = cookies
		configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
		
		configuration.HTTPAdditionalHeaders = defaultHeaders
		
		self.sessionManager = Alamofire.Manager(configuration: configuration)
		load_login_page()
	}
	
	func load_login_page() {
		self.last_Request = self.sessionManager.request(NSURLRequest(URL: NSURL(string: url_login)!))
	}
	
	func load_req(url: String) {
		self.last_Request = self.sessionManager.request(NSURLRequest(URL: NSURL(string: url)!))
	}
	
	func load_req_print(url: String) {
		self.last_Request = self.sessionManager.request(NSURLRequest(URL: NSURL(string: url)!))
			.responseString { (_, response, data, _) in
				print(data!)
		}
	}
	
	func login() {
		
		self.last_Request!.responseString { (_, _, string, _) in
			let params = [
				"username" : self.username,
				"password" : self.password,
				"warn" : "true",
				"lt" : Parser.getlt(string!),
				"_eventId" : "submit",
				"reset" : "CLEAR",
				"submit": "LOGIN"
			]
			
			self.last_Request = self.sessionManager.request(.POST, self.url_login, parameters: params)
				.responseString { (_, response, data, _) in
					var cook : NSHTTPCookie = self.cookies.cookiesForURL(NSURL(string: "https://sso.portal.mypisd.net/cas/")!)![1] as NSHTTPCookie
					//print(cook.domain + cook.path!)
					self.load_req_print("http://portal.mypisd.net/user/hid0112100000000000000076bb")
			}
			
			
		}
		

	}
}