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
		
		var session = Session(username: "enrico.borba.1", password: "inferno&7")
		session.getSixWeekGrades { (response, html_data) in
			//println(response)
			println(html_data)
			self.loadNextView()
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func loadNextView() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier(Storyboard.Login) as UIViewController
		
		self.presentViewController(vc, animated: false, completion: nil)
	}

}

