//
//  ABDropDownViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls
class ABDropDownViewController: UIViewController, ABDropDownDelegate {
	@IBOutlet weak private var textview: UITextView!
	@IBOutlet weak private var dropdown: ABDropDown!

	func didChangeIndex(_ index: Int) {
		switch index {
		case 0:
			textview.textColor = .red
		case 1:
			textview.textColor = .green
		case 2:
			textview.textColor = .blue
		case 3:
			textview.textColor = .black
		case 4:
			textview.textColor = .gray
		default:
			textview.textColor = .brown
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		dropdown.delegate = self
		// Do any additional setup after loading the view.
	}
}
