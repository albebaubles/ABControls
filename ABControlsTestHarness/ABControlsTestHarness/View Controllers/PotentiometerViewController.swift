//
//  ABPotentiometerViewcontrollerViewController.swift
//  ABControlsTestHarness
//
//  Created by Al Corbett on 12/23/20.
//  Copyright © 2020 AlbeBaubles LLC. All rights reserved.
//

import UIKit
import ABControls

class PotentiometerViewController: UIViewController {
    @IBOutlet weak private var linear: ABPotentiometerLinear!
    @IBOutlet weak private var radial: ABPotentiometerRadial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        radial.value = 99
        radial.color = UIColor.yellow
        radial.barWidth = 20

//        linear.value = 32
//        linear.color = UIColor.orange
//        linear.barWidth = 20
        
    }
}
