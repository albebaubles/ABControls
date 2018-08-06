//
//  ABControl.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

class ABControl: UIView {
    
    /// required for dev time
    required override public init(frame: CGRect) {
        super.init(frame:  frame)
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
    }
    
    private func sharedInit() {
        backgroundColor = super.backgroundColor
    }
    
}
