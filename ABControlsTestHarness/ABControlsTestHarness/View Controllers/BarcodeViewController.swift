//
//  ABScannerViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls

class BarcodeViewController: UIViewController, ABBarcodeScannerDelegate {
	@IBOutlet weak private var scanner: ABBarcodeScanner!
	@IBOutlet weak private var scanned: UIImageView!
	@IBOutlet weak private var created: UIImageView!
	@IBOutlet weak private var barcodeValue: UILabel!
    
	func didReceiveBarcode(_ code: ABBarcode) {
		DispatchQueue.main.async {
			code.type = "CIQRCodeGenerator"
			self.scanned.image = code.image()
			self.barcodeValue.text = code.stringData
		}
	}
    
	func didFail(_ message: String) {
		//
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
		scanner.delegate = self
        scanner.startCapturing()
        // CIPDF417BarcodeGenerator
        created.image = ABBarcode.create("CIPDF417BarcodeGenerator", "ABControls Rock!").image()
		// Do any additional setup after loading the view.
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        scanner.stopCapturing()
    }
}
