//
//  Grade.swift
//  onePISD
//
//  Created by Enrico Borba on 2/21/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Grade {
	let termID : Int
	let grade : Int
	let blank : Bool
	let minigrades : [MiniGrade]?
	
	init(termID: Int, grade: Int) {
		self.termID = termID
		self.grade = grade
		self.blank = false
	}
	
	init(blank: Bool) {
		self.termID = 0
		self.grade = 0
		self.blank = true
	}
}