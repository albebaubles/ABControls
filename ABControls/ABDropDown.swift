//
//  ABDropDown
//  ABControls
//
//  Created by Alan Corbett on 8/2/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit


/// Provides a dropdown list as a replacement for a UIPickerView.  If the dropdown cannot display without falling off the window, it will popUP
/// - Attention: fires notification 'ABDropDownDidChangeIndex' which returns the selected index


@objc @IBDesignable public class ABDropDown: UIView, UITableViewDelegate, UITableViewDataSource {
    private var _frame : CGRect = CGRect.init()
    private var _listItems: [String]?
    private var _selected : Int = NSNotFound
    private var _textColor : UIColor = UIColor.black
    private var _font : UIFont = UIFont.systemFont(ofSize: 14)
    private var _label: UILabel!
    private var _button : UIButton!
    private var _tableview: UITableView! = UITableView.init()
    private let dropdownHeight: CGFloat = 160
    private let defaultHeight: CGFloat = 30
    private let dropdownViewHeight: CGFloat = 130
    
    /// Notifications
    @objc  public static var ABDropDownDidChangeIndex : String = "ABDropDownDidChangeIndex"
    
    
    /// Sets the textcolor for text and the dropdown arrow
    @IBInspectable public var textColor : UIColor {
        didSet{
            _textColor = textColor
            for view in subviews {
                if view is UILabel {
                    (view as! UILabel).textColor = textColor
                } else if view is UIButton {
                    (view as! UIButton).tintColor = textColor
                    (view as! UIButton).titleLabel?.textColor = textColor
                }
            }
            _label.layer.borderColor = _textColor.cgColor
            _tableview.reloadData()
            setNeedsDisplay()
        }
    }
    
    
    /**
     The list of items to be displayed in the combobox seperated by \n (command-enter)
     */
    @IBInspectable  public var items : String = "" {
        didSet{
            _listItems = items.components(separatedBy: "\n")
            updateListItems(items: _listItems!)
            setNeedsDisplay()
        }
    }
    
    /// The currently selected index
    @IBInspectable  public var index : Int = NSNotFound {
        didSet{
            _selected = index
            #if !TARGET_INTERFACE_BUILDER
            _tableview.selectRow(at: IndexPath.init(row: _selected, section: 0), animated: false, scrollPosition: .middle)
            NotificationCenter.default.post(name: NSNotification.Name(  ABDropDown.ABDropDownDidChangeIndex), object: _selected)
            #endif
            
            if _selected == NSNotFound {
                _label.text = ""
            } else {
                _label.text = " \(items.components(separatedBy: "\n")[index])"
            }
            setNeedsDisplay()
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
            setNeedsDisplay()
        }
    }
    
    
    /// the current text being displayed based on the index
    public func text() -> String {
        if _selected != NSNotFound {
            return _listItems![_selected]
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
                                 height: defaultHeight)
        } else if _frame.origin.y + dropdownHeight >  (window?.screen.bounds.size.height)!  {
            frame =    CGRect.init(x: _frame.origin.x,
                                   y: _frame.origin.y - dropdownViewHeight,
                                   width: _frame.width,
                                   height: dropdownHeight)
        } else {
            frame =  CGRect.init(x: _frame.origin.x,
                                 y: _frame.origin.y,
                                 width: _frame.width,
                                 height: dropdownHeight)
        }
        setNeedsLayout()
        
    }
    
    /// required for dev time
    required override public init(frame: CGRect) {
        _frame = frame
        self.textColor = UIColor.black
        super.init(frame:   frame)
    }
    
    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        self.textColor = UIColor.black
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
        //        autoresizingMask = .init(rawValue: 0)
        
        // setup the ui controls
        _frame = frame
        setupDropdownButton()
        setupLabel()
        setupTableviewDropdown()
    }
    
    private func setupLabel() {
        _label = UILabel.init(frame: bounds)
        _label.layer.borderColor = _textColor.cgColor
        _label.layer.borderWidth = 0.5
        _label.text = "ABDropDown"
        addSubview(_label)
    }
    
    private func setupDropdownButton() {
        if _button == nil {
            let _button = UIButton.init(type: .system)
            _button.frame = CGRect.init(x: _frame.width - 30, y: 2.5, width: 25, height: 25)
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
        _tableview.frame = CGRect.init(x: 0, y: defaultHeight, width: frame.width - 20, height: dropdownViewHeight)
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
        if _listItems != nil {
            return (_listItems?.count)!
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.isUserInteractionEnabled = true
        cell.textLabel?.text = _listItems?[indexPath.row]
        cell.textLabel?.textColor = _textColor
        cell.textLabel?.font = _font
        cell.backgroundColor = self.backgroundColor
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        showList()
    }
}
