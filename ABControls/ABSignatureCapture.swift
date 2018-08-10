//
//  ABSignatureCapture.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit


/// Control for capturing a signature
@objc @IBDesignable public class  ABSignatureCapture: ABControl {
    private var sigPaths = UIBezierPath.init()
    
    /// Notifications
    @objc  public static let ABSignatureCaptureDidDrawSignature : String = "ABSignatureCaptureDidDrawSignature"
    
    /// Sets the textcolor for text and the dropdown arrow
    public var color : UIColor = UIColor.black {
        didSet{
            for view in subviews {
                if view is UILabel {
                    (view as! UILabel).textColor = color
                } else if view is UIButton {
                    (view as! UIButton).tintColor = color
                    (view as! UIButton).titleLabel?.textColor = color
                }
            }
            setNeedsDisplay()
        }
    }
    
    
    /// a false value will display a signatory line
    @IBInspectable public var isLineHidden : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.color.setStroke()
        sigPaths.stroke()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = super.cornerRadius
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sigPaths.move(to: (touches.first?.location(in: self))!)
    }
    
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sigPaths.addLine(to: (touches.first?.location(in: self))!)
        setNeedsDisplay()
    }
    
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let s = self.signature().base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        NotificationCenter.default.post(name: Notification.Name(ABSignatureCapture.ABSignatureCaptureDidDrawSignature),
                                        object:s)
    }
    
    
    /// Clears the signature
    @objc public func clearSignature() {
        sigPaths.removeAllPoints()
        layer.sublayers = nil;
    }
    
    
    
    /// Returns the captured signature
    ///
    /// - Returns: The bezier path of the signature as archive NSData
    @objc public func signature() -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: sigPaths) as NSData
    }
    
    
    /// Returns the signature
    ///
    /// - Returns: signature path as a UIBezierPath
    @objc public func signaturePath() -> UIBezierPath {
        return sigPaths
    }
    
    
    @objc public func signatureImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        color.setStroke()
        sigPaths.lineWidth = 2
        sigPaths.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc public func signature(path : UIBezierPath) {
        sigPaths = path
    }
    
    
    /// required for dev time
    required public init(frame: CGRect) {
        super.init(frame:  frame)
    }
    
    
    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
        layer.cornerRadius = super.cornerRadius
        let label = UILabel.init(frame: bounds.insetBy(dx: 20, dy: 20))
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.text = "ABSignatureCapture"
        addSubview(label)
    }

    func sharedInit() {
        if !isLineHidden {
            let sv = UIView.init(frame: CGRect.init(x: 10, y: bounds.height - 20, width: bounds.width - 20, height: 2))
            sv.backgroundColor = UIColor.lightGray
            addSubview(sv)
        }
    }
}
