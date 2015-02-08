//
//  FirstViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 2/7/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	func testRequest() {
		let session = PSession(username: "enrico.borba.1", password: "inferno&7")
		session.login()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		testRequest()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}


}

