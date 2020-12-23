//
//  ABCheckBoxViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls
class ABCheckboxViewController: UIViewController {
	@IBOutlet private weak var checkbox1: ABCheckbox!
	@IBOutlet private weak var checkbox2: ABCheckbox!
	@IBOutlet private weak var button: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		checkbox1.delegate = self
		checkbox2.delegate = self
		// Do any additional setup after loading the view.
	}
}

extension ABCheckboxViewController : ABCheckboxDelegate {
    func didChangeCheckboxSelection(_ sender: ABCheckbox) {
        if checkbox1.checked && checkbox2.checked {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
}
