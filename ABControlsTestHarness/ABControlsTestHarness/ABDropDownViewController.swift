//
//  ABDropDownViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls

class ABDropDownViewController: UIViewController {
    
    @IBOutlet weak private var textview: UITextView!
    @IBOutlet weak private var dropdown: ABDropDown!
    private let colors: [UIColor] = [.red, .green, .blue, .black, .brown, .purple]

    override func viewDidLoad() {
        super.viewDidLoad()

        dropdown?.delegate = self
    }
}

extension ABDropDownViewController: ABDropDownDelegate {
    
    func didChangeIndex(_ sender: ABDropDown, _ index: Int) {
        textview.textColor = colors[index]

    }

    func didShowDropdown() {

    }

    func didHideDropdown() {

    }
}
