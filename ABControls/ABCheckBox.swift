//
//  ABCheckBox.swift
//  ABControls
//
//  Created by Alan Corbett on 8/4/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc @IBDesignable public class ABCheckBox: UIView {
    private var _isChecked : Bool = false
    private var _button : UIButton = UIButton.init(type: .system)
    
    /// Notifications
    //[Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification
    // ABCheckBoxDidChange
    @objc  public static let ABCheckBoxDidChange : String = "ABCheckBoxDidChange"
    

    @IBInspectable public var isChecked : Bool = false {
        didSet {
            _isChecked = isChecked
                _button.setImage( _isChecked ? ABControlsStyleKit.imageOfCheckedBox :
                    ABControlsStyleKit.imageOfUncheckedBox, for: .normal)
            setNeedsDisplay()
            NotificationCenter.default.post(name: NSNotification.Name(  ABCheckBox.ABCheckBoxDidChange), object: _isChecked)
        }
    }
    

    
    /// Fires when the on/off value ofthe checkbox changes
    @objc private func checkboxChanged() {
        self.isChecked = !self.isChecked
        setNeedsDisplay()
        
        NotificationCenter.default.post(name: NSNotification.Name(  ABCheckBox.ABCheckBoxDidChange), object: _isChecked)
    }
    
    
    /// required for dev time
    required override public init(frame: CGRect) {
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
        sharedInit()
        _button.layer.borderColor = UIColor.black.cgColor
        _button.layer.borderWidth = 0.5
        self.isChecked = _isChecked
    }
    
    private func sharedInit() {
        autoresizingMask = .init(rawValue: 0)
//        if _button.image(for: .normal) == nil {
            setupCheckbox()
//        }
    }
    
    private func setupCheckbox() {
        _button.frame = bounds
        _button.setImage(ABControlsStyleKit.imageOfUncheckedBox , for: .normal)
        _button.addTarget(self, action: #selector(checkboxChanged), for: .touchUpInside)
        _button.backgroundColor = backgroundColor
        addSubview(_button)
    }
}
