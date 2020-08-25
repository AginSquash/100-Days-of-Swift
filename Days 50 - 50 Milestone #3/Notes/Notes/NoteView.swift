//
//  NoteView.swift
//  Notes
//
//  Created by Vlad Vrublevsky on 25.08.2020.
//

import UIKit

class NoteView: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var caption: UILabel!
    
    var notes: [Note]?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeCaption))
        
        let note = notes![index!]
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(note.image)
        imageView.image = UIImage(contentsOfFile: path.path)
        caption.text = note.caption
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func changeCaption() {
        let ac = UIAlertController(title: "Cahnge caption", message: "Enter new caption", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            let newCaption = ac?.textFields?[0].text
            self?.notes![self!.index!].caption = newCaption ?? "No caption"
            self?.caption.text = newCaption ?? "No caption"
            
            DispatchQueue.global(qos: .userInitiated).async {
                let encoded = try? JSONEncoder().encode(self?.notes)
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("notes")
                try? encoded?.write(to: path)
            }
        })
        
        present(ac, animated: true, completion: nil)
    }

}
