//
//  ABCheckBoxViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit
import ABControls

class ABCheckBoxViewController: UIViewController, ABCheckBoxDelegate {
    @IBOutlet weak var checkbox1: ABCheckBox!
    @IBOutlet weak var checkbox2: ABCheckBox!
    @IBOutlet weak var button: UIButton!
    
    func didChangeCheckboxSelection(_ checked: Bool) {
        if checkbox1.isChecked && checkbox2.isChecked {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkbox1.delegate = self
        checkbox2.delegate = self

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
