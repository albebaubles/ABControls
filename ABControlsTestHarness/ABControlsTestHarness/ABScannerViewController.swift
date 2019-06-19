//
//  ABScannerViewController.swift
//  ABControlsTestHarness
//
//  Created by Alan Corbett on 8/17/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import ABControls
class ABScannerViewController: UIViewController, ABBarcodeScannerDelegate {
	@IBOutlet weak private var scanner: ABBarcodeScanner!
	@IBOutlet weak private var scanned: UIImageView!
	@IBOutlet weak private var created: UIImageView!
	@IBOutlet weak private var barcodeValue: UILabel!
	func didReceiveBarcode(_ code: ABBarCode) {
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
		//	created.image = ABBarCode("CIQRCodeGenerator", "ABControls Rock!").image()
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
