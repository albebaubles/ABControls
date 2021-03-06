//
//  DetailViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
class DetailViewController: UIViewController {
	@IBOutlet weak private var detailDescriptionLabel: UILabel!
	func configureView() {
		// Update the user interface for the detail item.
		if let detail = detailItem {
			if let label = detailDescriptionLabel {
				label.text = detail.description
			}
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		configureView()
	}
    
	var detailItem: NSDate? {
		didSet {
			// Update the view.
			configureView()
		}
	}
}
