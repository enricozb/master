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
	
	//Static variable workaround. Thank you swift.
	private struct currentViewStruct {
		static var view : UIViewController?
	}
	
	class var currentView : UIViewController {
		get { return currentViewStruct.view! }
		set { currentViewStruct.view = newValue }
	}
	
	class func loadView(storyboardID: String, fromView: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let destinationView = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as UIViewController
		
		fromView.presentViewController(destinationView, animated: true, completion: nil)
	}
	class func showWaitOverlayWithText(string: String) {
		self.clearOverlays()
		currentView.showWaitOverlayWithText(string)
		println(string)
	}
	class func clearOverlays() {
		SwiftOverlays.removeAllOverlaysFromView(currentView.view)
	}
}