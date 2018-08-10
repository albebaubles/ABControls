//
//  ABListBox.swift
//  ABControls
//
//  Created by Alan Corbett on 8/5/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//

import UIKit

@objc @IBDesignable public class ABListBox: ABTextualControl, UITableViewDelegate, UITableViewDataSource {
    private var _frame : CGRect = CGRect.init()
    private var _listItems: [String]?
    private var _selected : Int = NSNotFound
    private var _font : UIFont = UIFont.systemFont(ofSize: 14)
    private var _tableview: UITableView! = UITableView.init()
    
    
    /// Notifications
    @objc  public static let ABListBoxDidChangeIndex : String = "ABListBoxDidChangeIndex"
    
    /// Sets the textcolor for text and the dropdown arrow
    override public var textColor : UIColor {
        didSet{
            super.textColor = textColor
            _tableview.reloadData()
        }
    }
    
    override var cornerRadius : CGFloat{
        didSet {
            super.cornerRadius = cornerRadius
            _tableview.layer.cornerRadius = cornerRadius
        }
    }
    
    
    /**
     The list of items to be displayed in the combobox seperated by \n (command-enter)
     */
    @IBInspectable  public var items : String = "" {
        didSet{
            _listItems = items.components(separatedBy: "\n")
            _tableview.reloadData()
        }
    }
    
    /// The currently selected index
    @IBInspectable  public var index : Int = NSNotFound {
        didSet{
            _selected = index
            #if !TARGET_INTERFACE_BUILDER
            _tableview.selectRow(at: IndexPath.init(row: _selected, section: 0), animated: false, scrollPosition: .middle)
            NotificationCenter.default.post(name: NSNotification.Name(  ABListBox.ABListBoxDidChangeIndex), object: _selected)
            #endif
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
        }
    }
    
    
    /// the current text being displayed based on the index
    public func text() -> String {
        if _selected != NSNotFound {
            return _listItems![_selected]
        }
        return ""
    }
    
    
    
    /// required for dev time
    required  public init(frame: CGRect) {
        _frame = frame
        super.init(frame:   frame)
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
        _tableview.selectRow(at: IndexPath.init(row: self.index, section: 0), animated: false, scrollPosition: .top)
        if items.count == 0 {
        let label = UILabel.init(frame: bounds.insetBy(dx: 20, dy: 20))
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.text = "ABListBox"
        addSubview(label)
        }
    }
    
    
    private func sharedInit() {
        autoresizingMask = .init(rawValue: 0)
        
        // setup the ui controls
        _frame = frame
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
        setupTableview()
        _tableview.reloadData()

    }
    
    
    
    
    private func setupTableview() {
        _tableview.autoresizingMask = .init(rawValue: 0)
        _tableview.dataSource = self
        _tableview.delegate = self
        _tableview.isHidden = false
        _tableview.indicatorStyle = .default
        _tableview.isUserInteractionEnabled = true
        _tableview.flashScrollIndicators()
        _tableview.rowHeight = 25
        _tableview.bounces = false
        _tableview.alwaysBounceVertical = false
        _tableview.alwaysBounceHorizontal = false
        _tableview.backgroundColor = self.backgroundColor
        _tableview.frame = bounds
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
        cell.textLabel?.textColor = textColor
        cell.textLabel?.font = _font
        cell.backgroundColor = self.backgroundColor
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
    }
}
