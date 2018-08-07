//
//  ABCheckBox.swift
//  ABControls
//
//  Created by Alan Corbett on 8/4/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc @IBDesignable public class ABCheckBox: UIView {
    
    /// Cache
    private struct Cache {
        static var isChecked : Bool = false
        static var button : UIButton = UIButton.init(type: .system)
    }
    
    /// Notifications
    //[Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification
    // ABCheckBoxDidChange
    @objc  public static var ABCheckBoxDidChange : String = "ABCheckBoxDidChange"
    

    @IBInspectable  public var isChecked : Bool = false {
        didSet {
            Cache.isChecked = isChecked
            Cache.button.setImage(Cache.isChecked ?  ABControlsStyleKit.imageOfCheckedBox :  ABControlsStyleKit.imageOfUncheckedBox , for: .normal)
            setNeedsDisplay()
            NotificationCenter.default.post(name: NSNotification.Name(  ABCheckBox.ABCheckBoxDidChange), object: Cache.isChecked)
        }
    }
    
    
    /// Sets the textcolor for text and the dropdown arrow
    @IBInspectable public var color : UIColor {
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
    
    
    @objc private func checkboxChanged() {
        Cache.isChecked = !Cache.isChecked
        isChecked = Cache.isChecked
        Cache.button.setImage(Cache.isChecked ?  ABControlsStyleKit.imageOfCheckedBox :  ABControlsStyleKit.imageOfUncheckedBox , for: .normal)
        setNeedsDisplay()
        
        NotificationCenter.default.post(name: NSNotification.Name(  ABCheckBox.ABCheckBoxDidChange), object: Cache.isChecked)
    }
    
    
    /// required for dev time
    required override public init(frame: CGRect) {
        self.color = UIColor.black
        super.init(frame:  frame)
        invalidateIntrinsicContentSize()
    }
    
    
    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        self.color = UIColor.black
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    private func sharedInit() {
        autoresizingMask = .init(rawValue: 0)
        if Cache.button.image(for: .normal) == nil {
            setupCheckbox()
        }
    }
    
    private func setupCheckbox() {
        Cache.button.frame = bounds
        Cache.button.setImage(ABControlsStyleKit.imageOfUncheckedBox , for: .normal)
        Cache.button.addTarget(self, action: #selector(checkboxChanged), for: .touchUpInside)
        Cache.button.backgroundColor = backgroundColor
        addSubview(Cache.button)
    }
}
