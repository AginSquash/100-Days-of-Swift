//
//  ViewController.swift
//  Challenge32
//
//  Created by Vlad Vrublevsky on 23.07.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddAlert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        toolbarItems = [spacer, shareButton, spacer]
        navigationController?.isToolbarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "element_cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    @objc func showAddAlert() {
        let ac = UIAlertController(title: "Enter new element", message: "", preferredStyle: .alert)
        ac.addTextField()
        
        let addElementAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            guard let element = ac?.textFields?[0].text else { return }
            self?.addElement(element)
        }
        ac.addAction(addElementAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
 
    @objc func refresh() {
        list = [String]()
        tableView.reloadData()
    }
    
    @objc func share() {
        let avc = UIActivityViewController(activityItems: [list.joined(separator: "\n")], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = toolbarItems![1]
        present(avc, animated: true)
    }
    
    func addElement(_ element: String) {
        list.insert(element, at: 0)
        let indexpath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexpath], with: .automatic)
    }
}

