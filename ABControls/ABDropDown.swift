//
//  ABDropDown
//  ABControls
//
//  Created by Alan Corbett on 8/2/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit


@objc public protocol ABDropDownDelegate : class {
    
    /// Fires when the selected has changed
    ///
    /// - Parameter index: index of the selected value
    @objc optional func didChangeIndex(_ index : Int)
    
    /// Fires when the dropdown is visible
    @objc optional func didShowDropdown()
    
    /// Fires when the dropdown is hidden
    @objc optional func didHideDropdown()
}

/// Provides a dropdown list as a replacement for a UIPickerView.  If the dropdown cannot display without falling off the window, it will popUP
/// - Attention: fires notification 'ABDropDownDidChangeIndex' which returns the selected index
@objc @IBDesignable public class ABDropDown: ABTextualControl, UITableViewDelegate, UITableViewDataSource {
    public weak var delegate : ABDropDownDelegate?
    private var _frame : CGRect = CGRect.init()
    private static var _listItems: [String]?
    private var _selected : Int = NSNotFound
    private var _font : UIFont = UIFont.systemFont(ofSize: 14)
    private var _label: UILabel!
    private var _button : UIButton!
    private var _tableview: UITableView! = UITableView.init()
    private let _dropdownHeight: CGFloat = 160
    private let _defaultHeight: CGFloat = 30
    private let _dropdownViewHeight: CGFloat = 130
    
    /// Notifications
    @objc  public static let ABDropDownDidChangeIndex : String = "ABDropDownDidChangeIndex"
    
    
    /// Sets the textcolor for text
    override public var textColor : UIColor {
        didSet{
            super.textColor = textColor
            _tableview.reloadData()
            setNeedsDisplay()
        }
    }
    
    
    /**
     The list of items to be displayed in the combobox seperated by \n (command-enter)
     */
    @IBInspectable  public var items : String = "" {
        didSet{
            ABDropDown._listItems = items.components(separatedBy: "\n")
            updateListItems(items: ABDropDown._listItems!)
            index = 0
            setNeedsDisplay()
        }
    }
    
    
    /// The currently selected index
    @IBInspectable  public var index : Int = 0 {
        didSet{
            if index < (ABDropDown._listItems?.count)! && index >= 0 {
                _selected = index
                _tableview.selectRow(at: IndexPath.init(row: _selected, section: 0), animated: false, scrollPosition: .middle)
                
                #if !TARGET_INTERFACE_BUILDER
                    NotificationCenter.default.post(name: NSNotification.Name(  ABDropDown.ABDropDownDidChangeIndex), object: _selected)
                    delegate?.didChangeIndex!(index)
                #endif
                
                if _selected == NSNotFound {
                    _label.text = ""
                } else {
                    _label.text = " \(items.components(separatedBy: "\n")[index])"
                }
                setNeedsDisplay()
            } else {
                self.index = oldValue
            }
        }
    }
    
    
    /// Sets the font, default is system font at 14pt
    @IBInspectable  public var font : UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            _font =  font
            for view in subviews {
                if view is UILabel {
                    (view as! UILabel).font = _font
                } else if view is UIButton {
                    (view as! UIButton).titleLabel?.font = _font
                }
            }
            _label.font = _font
            setNeedsDisplay()
        }
    }
    
    
    /// the current text being displayed based on the index
    public func text() -> String {
        if _selected != NSNotFound {
            return ABDropDown._listItems![_selected]
        }
        return ""
    }
    
    
    
    private func updateListItems(items: Array<String>) {
        if _label != nil {
            if (items.count) > 0 {
                _label.text = items[0]
            }
        }
        #if !TARGET_INTERFACE_BUILDER
        _tableview.reloadData()
        #endif
    }
    
    
    @objc private func showList() {
        _tableview.isHidden = !_tableview.isHidden
        
        /*
         if displaying the dropdown, we need to increase the
         height of the frame to accomodate.  Need to also
         check if the dropdown would fall offscreen and if so,
         popUP instead of down.
         */
        
        if _tableview.isHidden {
            frame =  CGRect.init(x: _frame.origin.x,
                                 y: _frame.origin.y,
                                 width: _frame.width,
                                 height: _defaultHeight)
            delegate?.didHideDropdown?()
        } else if _frame.origin.y + _dropdownHeight >  (window?.screen.bounds.size.height)!  {
            frame =    CGRect.init(x: _frame.origin.x,
                                   y: _frame.origin.y - _dropdownViewHeight,
                                   width: _frame.width,
                                   height: _dropdownHeight)
            delegate?.didShowDropdown?()
        } else {
            frame =  CGRect.init(x: _frame.origin.x,
                                 y: _frame.origin.y,
                                 width: _frame.width,
                                 height: _dropdownHeight)
            delegate?.didShowDropdown?()
        }
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        setNeedsLayout()
        
    }
    
    /// required for dev time
    required  public init(frame: CGRect) {
        _frame = frame
        super.init(frame:   frame)
        textColor = UIColor.black
    }
    
    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // make sure the popup is on TOP of any other views in the super
        layer.zPosition = 999
        textColor = UIColor.black
        
        #if !TARGET_INTERFACE_BUILDER
        sharedInit()
        #endif
        
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
        _tableview.selectRow(at: IndexPath.init(row: self.index, section: 0), animated: false, scrollPosition: .top)
        
        if ABDropDown._listItems != nil && ABDropDown._listItems!.count > 0 && self.index != NSNotFound {
            _label.text = ABDropDown._listItems![self.index]
        }
    }
    
    private func sharedInit() {
        // setup the ui controls
        _frame = frame
        setupDropdownButton()
        setupLabel()
        setupTableviewDropdown()
        _label.textColor = self.textColor
        _label.font = _font
    }
    
    private func setupLabel() {
        _label = UILabel.init(frame: bounds.insetBy(dx: 5, dy: 0))
        addSubview(_label)
    }
    
    
    private func setupDropdownButton() {
        if _button == nil {
            let _button = UIButton.init(type: .system)
            _button.frame = CGRect.init(x: bounds.width - 30, y: 2.5, width: 25, height: 25)
            _button.setImage(ABControlsStyleKit.imageOfDownArrow, for: .normal)
            _button.titleLabel?.font = _font
            addSubview(_button)
            setNeedsDisplay()
            #if !TARGET_INTERFACE_BUILDER
            _button.addTarget(self, action: #selector(showList), for: UIControlEvents.touchUpInside)
            #endif
        }
        
    }
    
    private func setupTableviewDropdown() {
        _tableview.frame = CGRect.init(x: 0, y: _defaultHeight, width: frame.width - 20, height: _dropdownViewHeight)
        _tableview.dataSource = self
        _tableview.delegate = self
        _tableview.isHidden = true
        _tableview.indicatorStyle = .default
        _tableview.isUserInteractionEnabled = true
        _tableview.flashScrollIndicators()
        _tableview.rowHeight = 25
        _tableview.bounces = false
        _tableview.alwaysBounceVertical = false
        _tableview.alwaysBounceHorizontal = false
        _tableview.backgroundColor = self.backgroundColor
        
        addSubview(_tableview)
    }
    
    
    // MARK: - Table view data source
    //
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ABDropDown._listItems != nil {
            return (ABDropDown._listItems?.count)!
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.isUserInteractionEnabled = true
        cell.textLabel?.text = ABDropDown._listItems?[indexPath.row]
        cell.textLabel?.textColor = textColor
        cell.textLabel?.font = _font
        cell.backgroundColor = self.backgroundColor
        cell.contentView.backgroundColor = self.backgroundColor
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        showList()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = self.backgroundColor
        cell.textLabel?.textColor = self.textColor
    }
}

