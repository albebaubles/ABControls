//
//  ABGradientViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit
import ABControls

class ABGradientViewController: UIViewController {
    @IBOutlet weak var gradient: ABGradientLinearView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient.colors = [UIColor.red, UIColor.blue, UIColor.green]
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
