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
