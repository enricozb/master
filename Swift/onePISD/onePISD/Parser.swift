//
//  Parser.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

/* TODO
	inout parameters for _form_ functions
	rewrite some shit
*/
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
		
		for _ in 1...50 {
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
	
	class func getReportTableFromHTML(html: String) -> [Course] {
		let divisorString = "<td class=\"gradeNumeric\" colspan=\"3\" title=\"\" >"
		let initGradesString = "<tr class='row"
		let endGradesString = "</tbody>"
		let endTitleString = "<th class=\"classTitle\" scope=\"row\">"
		let courseSeparatorString = "</tr>"
		
		
		var gradeString: String = html.substringFromIndex(html.rangeOfString(initGradesString)!.startIndex)
		gradeString = gradeString.substringToIndex(gradeString.rangeOfString(endGradesString)!.startIndex)
		
		//println(gradeString)
		
		var courseStrings = gradeString.componentsSeparatedByString(courseSeparatorString)
		
		courseStrings.removeLast()
		
		var courses = [Course]()
		for courseString in courseStrings {
			let possibleCourse = extractCourse(courseString)
			if let course = possibleCourse {
				courses.append(course)
			}
		}
		
		return courses
		
		//println(courseStrings)
		
		/*
		let scanner = NSScanner(string: gradeString)
		var stringBuffer: NSString?
		scanner.scanString(endTitleString, intoString: nil)
		scanner.scanUpToString(endCourseString, intoString: &stringBuffer)
		*/
		
	}
	
	private class func extractCourse(html: String) -> Course?{
		let scanner = NSScanner(string: html)
		var stringBuffer: NSString?
		
		scanner.scanUpToString("<a href", intoString: nil)
		scanner.scanUpToString("<th", intoString: &stringBuffer)
		let (title, enrollmentID) = extractClassTitleAndID(stringBuffer!)
		
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
	
		let period = (stringBuffer! as String).toInt()!
		var grades = [Grade]()
	
		scanner.scanUpToString("<td", intoString: nil) //Begin grade grabbing
		
		if scanner.scanString("<td class=\"disabledCell\"", intoString: nil) {
			return nil
		}
		
		for _ in 1...5 {
			scanner.scanUpToString("</td", intoString: &stringBuffer)
			let (grade, termID) = self.extractGradeAndTermID(stringBuffer!)
			if let tid = termID {
				grades.append(Grade(termID: tid, grade: grade))
			}
			else if grade != -1 {
				grades.append(Grade(termID: 0, grade: grade))
			}
			else {
				grades.append(Grade(blank: true))
			}
			scanner.scanUpToString("<td", intoString: nil)
		}
		
		if !scanner.scanString("<td", intoString: nil) {
			return Course(name: title, period: period, grades: grades, enrollmentID: enrollmentID)
		}
		
		for _ in 1...5 {
			scanner.scanUpToString("</td", intoString: &stringBuffer)
			let (grade, termID) = self.extractGradeAndTermID(stringBuffer!)
			if let tid = termID {
				grades.append(Grade(termID: tid, grade: grade))
			}
			else if grade != -1 {
				grades.append(Grade(termID: 1, grade: grade))
			}
			else {
				grades.append(Grade(blank: true))
			}
			scanner.scanUpToString("<td", intoString: nil)
		}
		
		return Course(name: title, period: period, grades: grades, enrollmentID: enrollmentID)
	}
	
	private class func extractClassTitleAndID(html: String) -> (String, Int) {
		//Comes in as <a href="javascript:ClassDetails.getClassDetails(...);">CLASS TITLE</a></th>
		var substring: String = html.substringFromIndex(html.rangeOfString(">")!.endIndex)
		let title =  substring.substringToIndex(substring.rangeOfString("<")!.startIndex)
		
		substring = html.substringFromIndex(html.rangeOfString("(")!.endIndex)
		let enrollmentID = substring.substringToIndex(substring.rangeOfString(")")!.startIndex).toInt()!
		
		return (title, enrollmentID)
	}
	
	private class func extractGradeAndTermID(html: String) -> (Int, Int?) {
		var scanner = NSScanner(string: html)
		var stringBuffer: NSString?
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("</td", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		if let grade = (stringBuffer! as String).toInt() {
			return (grade, nil)
		}
		else if stringBuffer!.length == 0 {
			return (-1, nil)
		}
		
		scanner = NSScanner(string: stringBuffer!)
		scanner.scanUpToString("TermId=", intoString: nil)
		scanner.scanUpToString("&", intoString: &stringBuffer) // EnrollmentId=3662962& <-
		stringBuffer = stringBuffer?.substringFromIndex(countElements("TermId="))
		
		let termID = (stringBuffer! as String).toInt()!
		
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		if stringBuffer?.length == 0 {
			return (-1, termID)
		}
		else {
			return ((stringBuffer! as String).toInt()!, termID)
		}
	}
}