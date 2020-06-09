//
//  ABCheckBox.swift
//  ABControls
//
//  Created by Alan Corbett on 8/4/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

public protocol ABCheckBoxDelegate: class {

    /// Fires anytime the checkbox is checked or unchecked
    ///
    /// - Parameter checked: true if checked
    func didChangeCheckboxSelection(_ sender: ABCheckBox)
}

@IBDesignable
public class ABCheckBox: ABControl {

    public weak var delegate: ABCheckBoxDelegate?
    private var button = UIButton()

    /// Notifications
    // ABCheckBoxDidChange
    public static let ABCheckBoxDidChange: String = "ABCheckBoxDidChange"
    @IBInspectable public var checked: Bool = false {
        didSet {
            button.setImage(checked ? ABControlsStyleKit.imageOfCheckedBox : ABControlsStyleKit.imageOfUncheckedBox,
                            for: .normal)
            #if !TARGET_INTERFACE_BUILDER
                NotificationCenter.default.post(name: NSNotification.Name(ABCheckBox.ABCheckBoxDidChange),
                                                object: self)
                delegate?.didChangeCheckboxSelection(self)
            #endif
        }
    }

    /// Fires when the on/off value ofthe checkbox changes
    @objc
    private func checkboxChanged() {
        self.checked = !self.checked
        setNeedsDisplay()
    }

    /// required for dev time
    required public init(frame: CGRect) {
        super.init(frame: frame)

        button.bounds = frame
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
        setupCheckbox()
    }

    private func setupCheckbox() {
        button.frame = bounds
        button.imageView?.frame = bounds
        button.addTarget(self, action: #selector(checkboxChanged), for: .touchUpInside)
        button.backgroundColor = backgroundColor
        button.setImage(checked ? ABControlsStyleKit.imageOfCheckedBox : ABControlsStyleKit.imageOfUncheckedBox,
                        for: .normal)
        addSubview(button)
    }
}
