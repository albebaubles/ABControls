//
//  ABDropDown
//  ABControls
//
//  Created by Alan Corbett on 8/2/18.
//  Copyright © 2018 AlbeBaubles LLC. All rights reserved.
//
import UIKit

public protocol ABDropDownDelegate: class {

    /// Fires when the selected has changed
    ///
    /// - Parameter index: index of the selected value
    func didChangeIndex(_ sender: ABDropDown, _ index: Int)
    /// Fires when the dropdown is visible
    func didShowDropdown()
    /// Fires when the dropdown is hidden
    func didHideDropdown()
}

/// Provides a dropdown list as a replacement for a UIPickerView.  If the dropdown cannot display without falling off the window, it will popUP
/// - Attention: fires notification 'ABDropDownDidChangeIndex' which returns the selected index
@IBDesignable
public class ABDropDown: ABTextualControl, UITableViewDelegate, UITableViewDataSource {
    public weak var delegate: ABDropDownDelegate?
    private var frameRect = CGRect()
    private var listItems: [String]?
    private var selected: Int = NSNotFound
    private var holdFont = UIFont.systemFont(ofSize: 14)
    private var label: UILabel!
    private var button = UIButton(type: .system)
    private var tableview = UITableView()
    private let dropdownHeight = CGFloat(160)
    private let defaultHeight = CGFloat(30)
    private let dropdownViewHeight = CGFloat(130)

    /// Notifications
    public static let ABDropDownDidChangeIndex = "ABDropDownDidChangeIndex"

    /// Sets the textcolor for text
    override public var textColor: UIColor {
        didSet {
            super.textColor = textColor

            tableview.reloadData()
            layer.borderColor = textColor.cgColor
            button.tintColor = textColor
            setNeedsDisplay()
        }
    }

    /**
     The list of items to be displayed in the combobox seperated by \n (command-enter)
     */
    @IBInspectable public var items: String = "" {
        didSet {
            listItems = items.components(separatedBy: "\n")
            updateListItems(items: listItems!)
            index = 0
            setNeedsDisplay()
        }
    }

    /// The currently selected index
    @IBInspectable public var index: Int = 0 {
        didSet {
            if index < (listItems?.count)! && index >= 0 {
                selected = index
                tableview.selectRow(at: IndexPath(row: selected, section: 0), animated: false, scrollPosition: .middle)
                #if !TARGET_INTERFACE_BUILDER
                    NotificationCenter.default.post(name: NSNotification.Name(ABDropDown.ABDropDownDidChangeIndex), object: selected)
                    delegate?.didChangeIndex(self, index)
                #endif
                if selected == NSNotFound {
                    label.text = ""
                } else {
                    label.text = " \(items.components(separatedBy: "\n")[index])"
                }
                setNeedsDisplay()
            } else {
                self.index = oldValue
            }
        }
    }

    /// Sets the font, default is system font at 14pt
    public var font = UIFont.systemFont(ofSize: 14) {
        didSet {
            holdFont = font
            for view in subviews {
                if view is UILabel {
                    (view as? UILabel)?.font = holdFont
                } else if view is UIButton {
                    (view as? UIButton)?.titleLabel?.font = holdFont
                }
            }
            label.font = holdFont
            setNeedsDisplay()
        }
    }

    /// the current text being displayed based on the index
    public func text() -> String {
        if selected != NSNotFound {
            return listItems![selected]
        }
        return ""
    }
    private func updateListItems(items: [String]) {
        if label != nil {
            if (items.count) > 0 {
                label.text = items[0]
            }
        }
        #if !TARGET_INTERFACE_BUILDER
            tableview.reloadData()
        #endif
    }

    @objc
    private func showList() {
        tableview.isHidden = !tableview.isHidden
        /*
         if displaying the dropdown, we need to increase the
         height of the frame to accomodate.  Need to also
         check if the dropdown would fall offscreen and if so,
         popUP instead of down.
         */
        if tableview.isHidden {
            frame = CGRect(x: frameRect.origin.x,
                y: frameRect.origin.y,
                width: frameRect.width,
                height: defaultHeight)
            delegate?.didHideDropdown()
        } else if frameRect.origin.y + dropdownHeight > (window?.screen.bounds.size.height)! {
            frame = CGRect(x: frameRect.origin.x,
                y: frameRect.origin.y - dropdownViewHeight,
                width: frameRect.width,
                height: dropdownHeight)
            delegate?.didShowDropdown()
        } else {
            frame = CGRect(x: frameRect.origin.x,
                y: frameRect.origin.y,
                width: frameRect.width,
                height: dropdownHeight)
            delegate?.didShowDropdown()
        }
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        setNeedsLayout()
    }

    /// required for dev time
    required public init(frame: CGRect) {
        frameRect = frame
        super.init(frame: frame)

        textColor = UIColor.black
    }

    /// require for runtime
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Make sure the popup is on TOP of any other views in the super
        layer.zPosition = 999
        textColor = UIColor.black
        #if !TARGET_INTERFACE_BUILDER
            sharedInit()
        #endif
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        sharedInit()
        if index != NSNotFound {
            tableview.selectRow(at: IndexPath(row: self.index, section: 0), animated: false, scrollPosition: .top)
        }
        label.text = listItems?[self.index]
    }

    private func sharedInit() {
        // Setup the ui controls
        frameRect = frame
        setupDropdownButton()
        setupLabel()
        setupTableviewDropdown()
        label.textColor = self.textColor
        label.font = holdFont
        button.tintColor = textColor
    }

    private func setupLabel() {
        label = UILabel(frame: bounds.insetBy(dx: 5, dy: 0))
        addSubview(label)
        label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func setupDropdownButton() {
        button.removeFromSuperview()
        button.frame = CGRect(x: bounds.width - 30, y: 2.5, width: 25, height: 25)
        button.setImage(ABControlsStyleKit.imageOfDownArrow, for: .normal)
        button.titleLabel?.font = holdFont
        button.tintColor = textColor
        button.titleLabel?.textColor = textColor
        addSubview(button)
        setNeedsDisplay()
        #if !TARGET_INTERFACE_BUILDER
            button.addTarget(self, action: #selector(showList), for: UIControl.Event.touchUpInside)
        #endif
    }

    private func setupTableviewDropdown() {
        tableview.frame = CGRect(x: 0, y: defaultHeight, width: frame.width - 20, height: dropdownViewHeight)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.isHidden = true
        tableview.indicatorStyle = .default
        tableview.isUserInteractionEnabled = true
        tableview.flashScrollIndicators()
        tableview.rowHeight = 25
        tableview.bounces = false
        tableview.alwaysBounceVertical = false
        tableview.alwaysBounceHorizontal = false
        tableview.backgroundColor = self.backgroundColor
        self.backgroundColor = self.backgroundColor
        addSubview(tableview)
        tableview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        layer.backgroundColor = self.backgroundColor?.cgColor
        layer.borderColor = self.textColor.cgColor
        layer.borderWidth = 0.5
    }

    // MARK: - Table view data source
    //
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems != nil ? (listItems?.count)! : 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.isUserInteractionEnabled = true
        cell.textLabel?.text = listItems?[indexPath.row]
        cell.textLabel?.textColor = textColor
        cell.textLabel?.font = holdFont
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        showList()
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = self.backgroundColor?.cgColor
    }
}
