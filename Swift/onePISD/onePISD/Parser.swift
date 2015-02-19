//
//  Parser.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Parser {
	class func getLTfromHTML(html: String) -> String {
		let range_start = html.rangeOfString("name=\"lt\" value=\"")
		let range_end = html.rangeOfString("name=\"_eventId\"")
		
		var index_end = range_end!.startIndex
		
		for i in 0...31 {
			index_end = index_end.predecessor()	//It's sad how bad swift actually is.
		}
		
		return html.substringWithRange(Range<String.Index>(start: range_start!.endIndex, end: index_end))
	}
	
	
	class func getUIDfromHTML(html: String) -> String {
		let index_start = html.rangeOfString("\"uID\" value=\"")!.endIndex
		var index_end = index_start
		
		for i in 1...50 {
			index_end = index_end.successor()
		}
		
		return html.substringWithRange(Range<String.Index>(start: index_start, end: index_end))
	}
	
	class func getRedirectfromHTML(html: String) -> String {
		let index_start = html.rangeOfString("<a href=\"")!.endIndex
		let index_end = html.rangeOfString("\">here</a>")!.startIndex
		return html.substringWithRange(Range<String.Index>(start: index_start, end: index_end))
	}
	
	class func getGradeFormFromHTML(html: String) -> [String : String] {
		let form = [
			"action"	: "trans",
			"uT"		: "S",
			"uID"		: self.getUIDfromHTML(html)
		]
		return form
	}
	
	class func getPinnacleFormFromHTML(html: String) -> [String : String] {
		var form = [String : String]()
		
		var scanner: NSScanner
		var index_start: String.Index
		var substring: String
		
		let form_names = ["userId", "password"]

		for name in form_names {
			index_start = html.rangeOfString("\"\(name)\" value=\"")!.endIndex
			substring = html.substringFromIndex(index_start)
			
			scanner = NSScanner(string: substring)
			
			let endString = "\"/></td>"
			
			var value: NSString?
			scanner.scanUpToString(endString, intoString: &value)
			
			form[name] = value
		}
		return form
	}
}