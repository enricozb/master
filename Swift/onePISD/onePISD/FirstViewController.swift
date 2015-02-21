//
//  FirstViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		View.currentView = self
		/*
		var session = Session(username: "enrieco.borba.1", password: "inferno&7")
		session.getSixWeekGrades { (response, html_data, error) in
			//println(response)
			if error == SessionError.wrongCredentials {
				println("wrong password")
			}
			else {
				println(html_data)
			}
		}
		*/
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

