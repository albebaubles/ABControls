//
//  ABBarcodeScanner.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit
import AVFoundation

/// In this iteration the scanner object is always on and active
public protocol ABBarcodeScannerDelegate: class {

    /// Fires when the control has found and proceessed a barcode
    ///
    /// - Parameter code: reutns an ABBarcode object
    func didReceiveBarcode(_ code: ABBarcode)
    /// Fires anytime a problem occurs while attempting to scan a barcode
    ///
    /// - Parameter message: string indicating the problem/issue
    func didFail(_ message: String)
}

/// Uses the camera to scan a barcode
@IBDesignable
public class ABBarcodeScanner: ABControl {

    public weak var delegate: ABBarcodeScannerDelegate?
    private let camera = AVCaptureDevice.default(for: .video)
    private let session = AVCaptureSession()
    private var video: AVCaptureDeviceInput?
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var meta = AVCaptureMetadataOutput()

    /// Notifications
    public static let ABBarcodeScannerDidReceiveBarcode: String = "ABBarcodeScannerDidReceiveBarcode"
    public static let ABBarcodeScannerDidFail: String = "ABBarcodeScannerDidFail"

    /// A string array of acceptable barcode types. A nil value will scan for all barcodetype
    /// ex.
    ///     CICode128BarcodeGenerator,
    ///     CIAztecCodeGenerator,
    ///     CICode128BarcodeGenerator
    var barcodeTypes: [String] = [] {
        didSet {
            setupBarcodeCapture()
        }
    }

    /// required for dev time
    required public init(frame: CGRect) {
        super.init(frame: frame)

        invalidateIntrinsicContentSize()
    }
    

    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        #if !TARGET_INTERFACE_BUILDER
            sharedInit()
        #endif
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        sharedInit()
    }

    public func startCapturing() {
        session.startRunning()
    }
    
    public func stopCapturing() {
        session.stopRunning()
    }
    
    private func sharedInit() {
        autoresizingMask = .init(rawValue: 0)
        let share = UIView(frame: CGRect(x: 2, y: bounds.height / 2,
                                         width: bounds.width - 4, height: 2))
        share.backgroundColor = UIColor.red
        share.layer.zPosition = 1
        addSubview(share)
        // Display the controls type label while in IB
        #if TARGET_INTERFACE_BUILDER
            let label = UILabel(frame: bounds.insetBy(dx: 20, dy: 20))
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            // \n so the label won't render on top of line
            label.text = "ABBarcodeScanner\n"
            label.numberOfLines = 2
            label.layer.zPosition = 1
            addSubview(label)
        #endif
        #if !TARGET_INTERFACE_BUILDER
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                // Access granted
                self.setupBarcodeCapture()
            } else {
                self.delegate?.didFail("ABBarcodeScanner does not have access to the camera")
                NotificationCenter.default.post(name: NSNotification.Name(ABBarcodeScanner.ABBarcodeScannerDidFail), object: nil)
            }
        }
        #endif
    }

    ///
    private func setupBarcodeCapture() {
        if camera == nil {
            delegate?.didFail("ABBarcodeScanner : device does not have a camera")
            NotificationCenter.default.post(name: NSNotification.Name(ABBarcodeScanner.ABBarcodeScannerDidFail), object: nil)
            return
        }
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            do {
                try video = AVCaptureDeviceInput(device: camera!)
                if session.canAddInput(video!) {
                    session.addInput(video!)
                    previewLayer = AVCaptureVideoPreviewLayer(session: session)
                    previewLayer.videoGravity = .resizeAspectFill
                    DispatchQueue.main.async {
                        self.previewLayer.frame = self.bounds
                        self.layer.addSublayer(self.previewLayer)
                    }
                    meta.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "com.albebaubles.ABBarcodecapturequeue"))
                    if session.canAddOutput(meta) {
                        session.addOutput(meta)
                    }
                }
  
                meta.metadataObjectTypes = meta.availableMetadataObjectTypes
            } catch {
                /// TODO : fire a delegate message, somethign went wrong
            }
        } else {
            delegate?.didFail("ABBarcodeScanner did not receive access to the camera")
            NotificationCenter.default.post(name: NSNotification.Name(ABBarcodeScanner.ABBarcodeScannerDidFail), object: nil)
        }
    }
}

extension ABBarcodeScanner: AVCaptureMetadataOutputObjectsDelegate {

    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        for metaData in metadataObjects {
            if let code = previewLayer.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject {
                if metaData is AVMetadataMachineReadableCodeObject {
                    let barcode = ABBarcode.process(meta: code) as ABBarcode
                    if  barcodeTypes.contains(code.type.rawValue) || barcodeTypes.isEmpty {
                        self.delegate?.didReceiveBarcode(barcode)
                    }
                }
            }
        }
    }
}
