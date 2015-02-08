//
//  PSession.swift
//  onePISD
//
//  Created by Enrico Borba on 2/7/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import WebKit

class PSession: UIWebView, UIWebViewDelegate{
	let session: UIWebView
	let username: String
	let password: String
	
	init(username: String, password: String) {
		self.session = UIWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		let url_req = NSURLRequest(URL: NSURL(string: "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin")!)
		self.session.loadRequest(url_req)
		self.username = username
		self.password = password
		super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func login() {
		print(self.session.stringByEvaluatingJavaScriptFromString("document.body.innerHTML"))
	}
	
	func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
		print("error loading")
	}
	
	
	func webViewDidStartLoad(webView: UIWebView) {
		
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		
	}
}