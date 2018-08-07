//
//  ABSignatureCapture.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc @IBDesignable public class  ABSignatureCapture: ABControl {
    var sigPaths = UIBezierPath.init()

    /// Notifications
    @objc  public static var ABSignatureCaptureDidDrawSignature : String = "ABSignatureCaptureDidDrawSignature"

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.blue.setStroke()
        sigPaths.stroke()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sigPaths.move(to: (touches.first?.location(in: self))!)
        setNeedsDisplay()
    }
    
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sigPaths.addLine(to: (touches.first?.location(in: self))!)
        setNeedsDisplay()
    }
    
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNeedsDisplay()
        let s = self.signature().base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        NotificationCenter.default.post(name: Notification.Name(ABSignatureCapture.ABSignatureCaptureDidDrawSignature),
                                        object:s)
    }
    
    @objc public func clearSignature() {
        sigPaths.removeAllPoints()
        setNeedsDisplay()
        layer.sublayers = nil;
    }
    
    
    @objc public func signature() -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: sigPaths) as NSData
    }

    @objc public func signaturePath() -> UIBezierPath {
        return sigPaths
    }

    
    @objc public func signature(path : UIBezierPath) {
        sigPaths = path
        setNeedsDisplay()
    }
    
}

