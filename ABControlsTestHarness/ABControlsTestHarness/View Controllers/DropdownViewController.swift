//
//  ABDropDownViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls

class DropdownViewController: UIViewController {
    
    @IBOutlet weak private var textview: UITextView!
    @IBOutlet weak private var dropdown: ABDropdown!
    private let colors: [UIColor] = [.red, .green, .blue, .black, .gray, .purple, .cyan]

    override func viewDidLoad() {
        super.viewDidLoad()

        dropdown?.delegate = self
    }
}

extension DropdownViewController: ABDropdownDelegate {
    
    func didChangeIndex(_ sender: ABDropdown, _ index: Int) {
        textview.textColor = colors[index]

    }

    func didShowDropdown() {

    }

    func didHideDropdown() {

    }
}
