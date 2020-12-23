//
//  ABDropDownViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls

class ABDropdownViewController: UIViewController {
    
    @IBOutlet weak private var textview: UITextView!
    @IBOutlet weak private var dropdown: ABDropdown!
    private let colors: [UIColor] = [.red, .green, .blue, .black, .brown, .purple]

    override func viewDidLoad() {
        super.viewDidLoad()

        dropdown?.delegate = self
    }
}

extension ABDropdownViewController: ABDropdownDelegate {
    
    func didChangeIndex(_ sender: ABDropdown, _ index: Int) {
        textview.textColor = colors[index]

    }

    func didShowDropdown() {

    }

    func didHideDropdown() {

    }
}
