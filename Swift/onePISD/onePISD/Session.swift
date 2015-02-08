import Foundation
import Alamofire

class Session {
	
	let url_login = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	
	let username: String
	let password: String
	let sessionManager: Alamofire.Manager
	
	init(user: String, pass: String) {
		self.username = user
		self.password = pass
		
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
		configuration.HTTPAdditionalHeaders = defaultHeaders
		
		self.sessionManager = Alamofire.Manager(configuration: configuration)
	}
	
	func login() {
		let params = ["username" : self.username, "password" : self.password, "_eventId" : "submit"]
		var a = sessionManager.request(NSURLRequest(URL: NSURL(string: "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin")!)).response
		sessionManager.request(.POST, url_login, parameters: params)
			.responseString	{ (request, response, data, error) in
							println("request: \n \(request)")
							println("response: \n \(response)")
							println("error: \n \(error)")
							println("data: \n \(data)")
						}
	}
}