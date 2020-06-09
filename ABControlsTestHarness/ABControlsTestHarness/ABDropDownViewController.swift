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
    func didChangeIndex(_ sender: ABDropDown, _ index: Int) {

    }

    func didShowDropdown() {

    }

    func didHideDropdown() {

    }

    @IBOutlet weak private var textview: UITextView!
    @IBOutlet weak private var dropdown: ABDropDown!
    private let colors: [UIColor] = [.red, .green, .blue, .black, .brown]

    func didChangeIndex(_ index: Int) {
        textview.textColor = colors[index]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dropdown?.delegate = self
    }
}
