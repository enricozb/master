//
//  Parser.swift
//  onePISD
//
//  Created by Enrico Borba on 2/7/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import Alamofire

class Parser {
	
	//Swift is actually stupid (class variables not supported...)
	private struct return_struct { static var static_var: String? }
	
	class var global_return : String? {
		get { return return_struct.static_var }
		set { return_struct.static_var = newValue }
	}
	
	
	//Never have I written such a shit method before in my life. Thank you Swift for complicating substrings.
	class func getlt(string : String) -> String {
		//println(string)
		let range_1 = string.rangeOfString("name=\"lt\" value=\"")
		let range_2 = string.rangeOfString("name=\"_eventId\"")
		var end = range_2!.startIndex
		for i in 0...31 {
			end = end.predecessor()
		}
		var a = Range<String.Index>(start: range_1!.endIndex, end: end)
		return string.substringWithRange(a)
	}
	
	class func get_eventId() -> String {
		return ""
	}
}