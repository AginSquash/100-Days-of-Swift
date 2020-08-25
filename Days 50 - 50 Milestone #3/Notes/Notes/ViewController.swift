//
//  ViewController.swift
//  Notes
//
//  Created by Vlad Vrublevsky on 24.08.2020.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var notes = [Note]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        DispatchQueue.global(qos: .userInitiated).async {
            let path = self.getDocumentsDirectory().appendingPathComponent("notes")
            if let data = try? Data(contentsOf: path) {
                if let decoded = try? JSONDecoder().decode([Note].self, from: data) {
                    self.notes = decoded
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCellTableViewCell else {
            fatalError("NoteCell dequeueReusableCell is nil")
        }
        
        cell.caption.text = notes[indexPath.row].caption
        let path = getDocumentsDirectory().appendingPathComponent(notes[indexPath.row].image)
        cell.imagePreivew.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "NoteView") as? NoteView {
            vc.index = indexPath.row
            vc.notes = notes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addNote() {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: imagePath)
        }
        
        dismiss(animated: true, completion: nil)
        
        let ac = UIAlertController(title: "Add caption", message: "Enter caption", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            let newCaption = ac?.textFields?[0].text ?? "No caption"
            self?.notes.append(Note(caption: newCaption, image: imageName))
            self?.tableView.reloadData()
            self?.save()
        })
        present(ac, animated: true, completion: nil)
        
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func save() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let encoded = try? JSONEncoder().encode(self.notes) {
                let path = self.getDocumentsDirectory().appendingPathComponent("notes")
                try? encoded.write(to: path, options: .atomic)
            }
        }
    }
    
}

