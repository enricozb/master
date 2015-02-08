//
//  PISDWebView.swift
//  onePISD
//
//  Created by Enrico Borba on 2/7/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import WebKit

class PISDWebView: UIWebView, UIWebViewDelegate {
	
	let url_login = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	
	let session_type : String
	
	init(session_type: String) {
		self.session_type = session_type
		var nil_rect = CGRect(x: 0, y: 0, width: 0, height: 0)
		super.init(frame: nil_rect)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func loadloginpage() {
		var login_req = NSURLRequest(URL: NSURL(string: url_login)!)
		self.loadRequest(login_req)
	}
	
	func login() {
		
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		print("FINISHED LOADING")
	}
}