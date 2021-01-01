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
        signature.animateDrawing(pencil)
    }
}
