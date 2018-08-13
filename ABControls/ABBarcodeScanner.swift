//
//  ABBarcodeScanner.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit
import AVFoundation

@objc public class ABBarCode : NSObject {
    @objc public var  type : String?
    @objc public var  stringData : String?
    
    @objc internal static func processBarcode(meta : AVMetadataMachineReadableCodeObject) -> ABBarCode {
        let code = ABBarCode.init()
        code.type = meta.type.rawValue
        code.stringData = meta.stringValue
        
        return code
    }
    
    @objc public func image() -> UIImage {
        guard let data = stringData!.data(using: .ascii),
            let filter = CIFilter(name: type!) else {
                return UIImage.init()
        }
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let image = filter.outputImage else {
            return UIImage.init()
        }
          return UIImage(ciImage: image)
    }
}

@objc protocol ABBarcodeScannerDelegate : class {
    @objc func didReceiveBarcode(_ code : ABBarCode)
    @objc func didFail(_ message : String)
}


@objc @IBDesignable public class  ABBarcodeScanner : ABControl, AVCaptureMetadataOutputObjectsDelegate {
    private weak var _delegate : ABBarcodeScannerDelegate?
    private let _camera =  AVCaptureDevice.default(for: .video)
    private let _session = AVCaptureSession.init()
    private var _video : AVCaptureDeviceInput?
    private var _previewLayer =  AVCaptureVideoPreviewLayer.init()
    private var _meta = AVCaptureMetadataOutput.init()
    
    
    /// A string array of acceptable barcode types. A nil value will scan for all barcodetype
    /// ex. CICode128BarcodeGenerator
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
        label.text = "\nABBarcodeScanner"
        label.numberOfLines = 2
        label.layer.zPosition = 1
        addSubview(label)
        #endif
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                self.setupBarcodeCapture()
            } else {
                self._delegate?.didFail("device does not have access to the camera")
                
            }
        }
    }
    
    
    private func setupBarcodeCapture() {
        if _camera == nil {
            _delegate?.didFail("device does not have a camera")
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
            _delegate?.didFail("Did not receive access to the camera")
        }
    }
    
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for  metaData in metadataObjects {
            if metaData is AVMetadataMachineReadableCodeObject {
                let code = _previewLayer.transformedMetadataObject(for: metaData)
                let barcode = ABBarCode.processBarcode(meta: code as! AVMetadataMachineReadableCodeObject)
                if barcodeTypes.contains(code!.type.rawValue) {
                    _delegate?.didReceiveBarcode(barcode)
                    _session.stopRunning()
                }
            }
        }
    }
}




