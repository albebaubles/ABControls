//
//  ABSignatureViewController.swift
//  ABControlsTestHarness
//
//  Created by Al Corbett on 12/24/20.
//  Copyright © 2020 AlbeBaubles LLC. All rights reserved.
//

import UIKit
import ABControls

class SignatureViewController: UIViewController {
    @IBOutlet weak var signature: ABSignatureCapture!
    
    @IBOutlet weak var pencil: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clear(_ sender: Any) {
        signature.clearSignature()
    }
    
    @IBAction func accept(_ sender: Any) {
        signature.acceptSignature()
//        label.text = signature.sig()
        signature.animateDrawing(pencil)
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
