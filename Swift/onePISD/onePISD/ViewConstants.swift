//
//  ViewConstants.swift
//	Used for Storyboard constant convinience
//  onePISD
//
//  Created by Enrico Borba on 2/19/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//
import UIKit

public struct Storyboard {
	static let Login = "LoginView"
	static let Main = "MainTabView"
}

public class View {
	class func loadView(storyboardID: String, fromView: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationView = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as UIViewController
		
		fromView.presentViewController(destinationView, animated: true, completion: nil)
	}
}