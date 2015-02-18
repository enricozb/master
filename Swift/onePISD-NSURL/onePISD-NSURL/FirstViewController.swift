//
//  FirstViewController.swift
//  onePISD-NSURL
//
//  Created by Enrico Borba on 2/12/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		var session = PISDSession(username: "enrico.borba.1@mypisd.net", password: "inferno&7")
		session.login()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

