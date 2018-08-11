//
//  ABCheckBox.swift
//  ABControls
//
//  Created by Alan Corbett on 8/4/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc protocol ABCheckBoxDelegate : class {
    
    /// Fires anytime the checkbox is checked or unchecked
    ///
    /// - Parameter checked: true if checked
    @objc optional func didChangeCheckboxSelection(_ checked : Bool)
}

@objc @IBDesignable public class ABCheckBox: ABControl {
    private weak var _delegate : ABCheckBoxDelegate?
    private var _button : UIButton = UIButton.init(type: .system)
    
    /// Notifications
    //[Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification
    // ABCheckBoxDidChange
    @objc  public static let ABCheckBoxDidChange : String = "ABCheckBoxDidChange"
    

    @IBInspectable public var isChecked : Bool = false {
        didSet {
                _button.setImage( isChecked ? ABControlsStyleKit.imageOfCheckedBox :
                    ABControlsStyleKit.imageOfUncheckedBox, for: .normal)
            setNeedsDisplay()
            #if !TARGET_INTERFACE_BUILDER

            NotificationCenter.default.post(name: NSNotification.Name(  ABCheckBox.ABCheckBoxDidChange), object: isChecked)
            _delegate?.didChangeCheckboxSelection!(isChecked)
            #endif
        }
    }
    

    
    /// Fires when the on/off value ofthe checkbox changes
    @objc private func checkboxChanged() {
        self.isChecked = !self.isChecked
        setNeedsDisplay()
        
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
        _button.layer.borderColor = UIColor.black.cgColor
        _button.layer.borderWidth = 0.5
    }
    
    private func sharedInit() {
        autoresizingMask = .init(rawValue: 0)
            setupCheckbox()
    }
    
    private func setupCheckbox() {
        _button.frame = bounds
        _button.setImage(ABControlsStyleKit.imageOfUncheckedBox , for: .normal)
        _button.addTarget(self, action: #selector(checkboxChanged), for: .touchUpInside)
        _button.backgroundColor = backgroundColor
        addSubview(_button)
    }
}
