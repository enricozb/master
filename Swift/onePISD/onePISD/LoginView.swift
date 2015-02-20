//
//  Login.swift
//  onePISD
//
//  Created by Enrico Borba on 2/19/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class LoginView : UIViewController {
	
	let backgroundColor = UIColor(red: 0.290196078, green: 0.392156863, blue: 0.568627451, alpha: 1)
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	@IBAction func loginButtonPressed(sender: UIButton) {
		println(usernameTextField.text)
		println(passwordTextField.text)
		View.loadView(Storyboard.Main, fromView: self)
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = self.backgroundColor
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
}