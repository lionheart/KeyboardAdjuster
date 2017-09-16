//
//  ViewController.swift
//  TestApplication
//
//  Created by Daniel Loewenherz on 2/18/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

import UIKit
import KeyboardAdjuster

class ViewController: UIViewController, KeyboardAdjuster, UITableViewDelegate, UITableViewDataSource {
    let CellIdentifier = "CellIdentifier"

    var keyboardAdjustmentHelper = KeyboardAdjustmentHelper()

    var tableView: UITableView!
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "KeyboardAdjuster"
        
        textField = UITextField()
        textField.placeholder = "Library Name"
        textField.translatesAutoresizingMaskIntoConstraints = false

        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)

        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        keyboardAdjustmentHelper.constraint = view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        keyboardAdjustmentHelper.constraint?.isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activateKeyboardAdjuster()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deactivateKeyboardAdjuster()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)! as UITableViewCell
        switch (indexPath as NSIndexPath).section {
        case 0:
            cell.addSubview(textField)
            textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textField.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15).isActive = true
            textField.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
            textField.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 15).isActive = true
            textField.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15).isActive = true
            
        case 1:
            cell.textLabel?.text = "Row \((indexPath as NSIndexPath).row)"
            
        default:
            break
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        textField.resignFirstResponder()

        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}

