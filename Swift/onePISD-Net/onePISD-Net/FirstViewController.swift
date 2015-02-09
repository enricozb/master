//
//  FirstViewController.swift
//  onePISD-Net
//
//  Created by Enrico Borba on 2/8/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let session = Session("enrico.borba.1", "inferno&7")
		session.login()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

