//
//  ABControl.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@IBDesignable public class ABControl: UIView {
    
    private struct Cache {
        static var textColor : UIColor = UIColor.black
    }

    
    /// Sets the textcolor for text and the dropdown arrow
    @IBInspectable public var textColor : UIColor {
        didSet{
            Cache.textColor = textColor
            for view in subviews {
                if view is UILabel {
                    (view as! UILabel).textColor = textColor
                } else if view is UIButton {
                    (view as! UIButton).tintColor = textColor
                    (view as! UIButton).titleLabel?.textColor = textColor
                }
            }
            setNeedsDisplay()
        }
    }
    
    /// required for dev time
    required override public init(frame: CGRect) {
        textColor = Cache.textColor
        super.init(frame:  frame)
    }
    
    
    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        textColor = Cache.textColor
        super.init(coder: aDecoder)
        #if !TARGET_INTERFACE_BUILDER
        sharedInit()
        #endif
    }
    
    override public func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    private func sharedInit() {
        backgroundColor = super.backgroundColor
        textColor = Cache.textColor
    }
    
}
