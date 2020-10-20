//
//  ViewController.swift
//  Notes
//
//  Created by Vlad Vrublevsky on 20.10.2020.
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        
        title = "Notes"
       
        loadNotes()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cellTV = cell as? TableViewCell {
            cellTV.label.text = notes[indexPath.row].name
            return cellTV
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            vc.notes = self.notes
            let currentNode = self.notes[indexPath.row]
            vc.currentNote = currentNode
            vc.callback = { [self, currentNode, indexPath] (name: String, text: String) -> Void in
                print("Start callback")
                if (name == currentNode.name)&&(text == currentNode.text) {
                    print("Equeval")
                    return
                }
                
                self.notes[indexPath.row].name = name
                self.notes[indexPath.row].text = text
                
                reloadTableView()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ac = UIAlertController(title: "Delete", message: "You sure wont delete \(self.notes[indexPath.row].name)?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
                self.notes.remove(at: indexPath.row)
                self.reloadTableView()
            }
            ac.addAction(delete)
            present(ac, animated: true, completion: nil)
        }
    }
    
    @objc func newNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            vc.notes = self.notes
            vc.callback = { [self] (name: String, text: String) -> Void in
                self.notes.append( Note(id: UUID(), name: name, text: text) )
                self.reloadTableView()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func edit() {
        UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.isEditing.toggle()}, completion: nil)
    }
    
    func reloadTableView() {
        UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    func loadNotes() {
        DispatchQueue.global(qos: .userInitiated).async {
            let notesDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Notes")
            if let encoded = try? Data(contentsOf: notesDataURL) {
                print("Loading")
                if let decoded = try? JSONDecoder().decode([Note].self, from: encoded) {
                    DispatchQueue.main.async {
                        self.notes = decoded
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
}

