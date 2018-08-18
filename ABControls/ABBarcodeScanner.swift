//
//  ABBarcodeScanner.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit
import AVFoundation


/// ABBarcode contains the data and type of barcode
@objc public class ABBarCode : NSObject {
    @objc public var  type : String?
    @objc public var  stringData : String?
    
    
    /// Converts the AVMetadata to barcode data
    ///
    /// - Parameter meta: the AVMetadata to convert ot barcode data
    /// - Returns: an ABBarcode
    @objc internal static func processBarcode(meta : AVMetadataMachineReadableCodeObject) -> ABBarCode {
        let code = ABBarCode.init()
        code.type = meta.type.rawValue
        code.stringData = meta.stringValue
        
        return code
    }
    
    
    /// returns an image object based on it's barcode data and type
    ///
    /// - Returns: returns an UIImage of the barcodes data in the object
    ///
    /**
     ABBarCode.init("CIQRCodeGenerator", "0122333223484984").image()
     ABBarCode.init("CIAztecCodeGenerator", "43543323535433").image()
     
     let barcode = ABBarCode.init("CIQRCodeGenerator", "24342344")
     let myImage = barcode.image()
     CIQRCodeGenerator
 */
    @objc public func image() -> UIImage {
        guard let data = stringData!.data(using: .ascii),
            let filter = CIFilter(name: type!) else {
                NSLog("did fail to create image")
                return UIImage.init()
        }
        filter.setValue(data, forKey: "inputMessage")
        guard let image = filter.outputImage else {
            return UIImage.init()
        }
        return UIImage(ciImage: image)
    }
    
    
    /// Creates a UIImage object from barcode data
    ///
    /// - Parameters:
    ///   - type: barcode type, eg. - CICode128BarcodeGenerator...
    ///   - stringData: the data that comprisies the barcode info
    /// - Returns: UIImage
    ///
    /**
     let barcode = ABBarCode.init("CICode128BarcodeGenerator", "0100859619004301171811182118061-05")
     */
    @objc public static func `init`(_ type : String, _ stringData : String) -> ABBarCode {
        let bc = ABBarCode.init()
        bc.type = type
        bc.stringData = stringData
        return bc
    }
}


/// In this iteration the scanner object is always on and active
@objc public protocol ABBarcodeScannerDelegate : class {
    
    /// Fires when the control has found and proceessed a barcode
    ///
    /// - Parameter code: reutns an ABBarcode object
    @objc func didReceiveBarcode(_ code : ABBarCode)
    
    
    /// Fires anytime a problem occurs while attempting to scan a barcode
    ///
    /// - Parameter message: string indicating the problem/issue
    @objc func didFail(_ message : String)
}



/// Uses the camera to scan a barcode
@objc @IBDesignable public class  ABBarcodeScanner : ABControl, AVCaptureMetadataOutputObjectsDelegate {
    public weak var delegate : ABBarcodeScannerDelegate?
    private let _camera =  AVCaptureDevice.default(for: .video)
    private let _session = AVCaptureSession.init()
    private var _video : AVCaptureDeviceInput?
    private var _previewLayer =  AVCaptureVideoPreviewLayer.init()
    private var _meta = AVCaptureMetadataOutput.init()
    
    /// Notifications
    @objc  public static let ABBarcodeScannerDidReceiveBarcode : String = "ABBarcodeScannerDidReceiveBarcode"
    @objc  public static let ABBarcodeScannerDidFail : String = "ABBarcodeScannerDidFail"

    
    /// A string array of acceptable barcode types. A nil value will scan for all barcodetype
    /// ex.
    ///     CICode128BarcodeGenerator,
    ///     CIAztecCodeGenerator,
    ///     CICode128BarcodeGenerator
    @objc @IBInspectable var barcodeTypes : [String] = [] {
        didSet {
        }
    }
    
    
    /// required for dev time
    required  public init(frame: CGRect) {
        super.init(frame:  frame)
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
    
    private func sharedInit() {
        autoresizingMask = .init(rawValue: 0)
        let sv = UIView.init(frame: CGRect.init(x: 2, y: bounds.height / 2,
                                                width: bounds.width - 4, height: 2))
        sv.backgroundColor = UIColor.red
        sv.layer.zPosition = 1
        addSubview(sv)
        
        // display the controls type label while in IB
        #if TARGET_INTERFACE_BUILDER
        let label = UILabel.init(frame: bounds.insetBy(dx: 20, dy: 20))
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        // \n so the label won't render on top of line
        label.text = "ABBarcodeScanner\n"
        label.numberOfLines = 2
        label.layer.zPosition = 1
        addSubview(label)
        #endif
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                self.setupBarcodeCapture()
            } else {
                self.delegate?.didFail("ABBarcodeScanner does not have access to the camera")
                NotificationCenter.default.post(name: NSNotification.Name(  ABBarcodeScanner.ABBarcodeScannerDidFail), object: nil)

            }
        }
    }
    
    
    /// 
    private func setupBarcodeCapture() {
        if _camera == nil {
            delegate?.didFail("ABBarcodeScanner : device does not have a camera")
            NotificationCenter.default.post(name: NSNotification.Name(  ABBarcodeScanner.ABBarcodeScannerDidFail), object: nil)

            return
        }
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            do {
                try _video = AVCaptureDeviceInput.init(device: _camera!)
                if _session.canAddInput(_video!) {
                    _session.addInput(_video!)
                    
                    _previewLayer = AVCaptureVideoPreviewLayer.init(session: _session)
                    _previewLayer.videoGravity = .resizeAspectFill
                    DispatchQueue.main.async {
                        self._previewLayer.frame = self.bounds
                        self.layer.addSublayer(self._previewLayer)
                    }
                    
                    _meta.setMetadataObjectsDelegate(self, queue: DispatchQueue.init(label: "com.albebaubles.abbarcodecapturequeue"))
                    
                    if _session.canAddOutput(_meta) {
                        _session.addOutput(_meta)
                    }
                }
                _session.startRunning()
                _meta.metadataObjectTypes = _meta.availableMetadataObjectTypes
            } catch  {
                
                /// TODO : fire a delegate message, somethign went wrong
            }
        } else {
            delegate?.didFail("ABBarcodeScanner did not receive access to the camera")
            NotificationCenter.default.post(name: NSNotification.Name(  ABBarcodeScanner.ABBarcodeScannerDidFail), object: nil)

        }
    }
    
    

    /// Fires when the camera has detected a barcode
    ///
    /// - Parameters:
    ///   - output: the metadata associated with the barcode
    ///   - metadataObjects: The metadat oobjects
    ///   - connection: the capture connection this applies to
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for  metaData in metadataObjects {
            if metaData is AVMetadataMachineReadableCodeObject {
                let code = _previewLayer.transformedMetadataObject(for: metaData)
                let barcode = ABBarCode.processBarcode(meta: code as! AVMetadataMachineReadableCodeObject)
                if barcodeTypes.contains(code!.type.rawValue) || barcodeTypes.count == 0 {
                    delegate?.didReceiveBarcode(barcode)
                    NotificationCenter.default.post(name: NSNotification.Name(  ABBarcodeScanner.ABBarcodeScannerDidReceiveBarcode), object: barcode)
                    _session.stopRunning()
                }
            }
        }
    }
}




