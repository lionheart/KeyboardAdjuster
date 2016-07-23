//
//  ViewController.swift
//  TestApplication
//
//  Created by Daniel Loewenherz on 2/18/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

import UIKit
import KeyboardAdjuster

extension UIViewController {
    
}

class ViewController: UIViewController, KeyboardAdjuster, UITableViewDelegate, UITableViewDataSource {
    let CellIdentifier = "CellIdentifier"

    var keyboardAdjusterConstraint: NSLayoutConstraint?
    var keyboardAdjusterAnimated: Bool? = false
    var tableView: UITableView!
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField = UITextField()
        textField.placeholder = "Library Name"
        textField.translatesAutoresizingMaskIntoConstraints = false

        tableView = UITableView(frame: CGRectZero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)

        view.addSubview(tableView)

        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        
        keyboardAdjusterConstraint = view.bottomAnchor.constraintEqualToAnchor(tableView.bottomAnchor)
        keyboardAdjusterConstraint?.active = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        activateKeyboardAdjuster()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        deactivateKeyboardAdjuster()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        default:
            return 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)! as UITableViewCell
        switch indexPath.section {
        case 0:
            cell.addSubview(textField)
            textField.heightAnchor.constraintEqualToConstant(30).active = true
            textField.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 15).active = true
            textField.leftAnchor.constraintEqualToAnchor(cell.leftAnchor, constant: 15).active = true
            textField.rightAnchor.constraintEqualToAnchor(cell.rightAnchor, constant: 15).active = true
            textField.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -15).active = true
            
        case 1:
            cell.textLabel?.text = "Row \(indexPath.row)"
            
        default:
            break
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        textField.resignFirstResponder()
    }
}

