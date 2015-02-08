//
//  FirstViewController.swift
//  onePISD-Pythonic
//
//  Created by Enrico Borba on 2/8/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	
	func test() {
		println("Testing...")
		let test_session = Session(username: "enrico.borba.1", password: "inferno&7")
		test_session.init_headers()
		test_session.login()
		
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		test()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

