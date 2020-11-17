//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Vlad Vrublevsky on 17.11.2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    var originalImage: UIImage?
    
    var text1: String = ""
    var text2: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(setImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportImage))
    }

    @objc func setImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        originalImage = image
        updateImageView()
    }
    
    func updateImageView() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = render.image { ctx in
            originalImage?.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black
            shadow.shadowBlurRadius = 10
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white,
                .shadow: shadow
            ]
            
            let attrString1 = NSAttributedString(string: text1, attributes: attrs)
            attrString1.draw(in: CGRect(x: 0, y: 5, width: 512, height: 52))
            
            let attrString2 = NSAttributedString(string: text2, attributes: attrs)
            attrString2.draw(in: CGRect(x: 0, y: 460, width: 512, height: 52))
        }
        
        imageView.image = img
    }
    
    
    @IBAction func pressed(_ sender: Any) {
        guard let btn = sender as? UIButton else { return }
        var stringChoosen: String = "Text"
        if btn.tag == 1 {
            stringChoosen = "Text 1"
        } else {
            stringChoosen = "Text 2"
        }
        
        let ac = UIAlertController(title: stringChoosen, message: "Enter text for \(stringChoosen)", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)

        let okButton = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            let textEntered = ac.textFields?[0].text ?? ""
            if btn.tag == 1 {
                self?.text1 = textEntered
            } else {
                self?.text2 = textEntered
            }
            
            self?.updateImageView()
        }
        
        ac.addAction(okButton)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func exportImage() {
        guard let image = self.imageView.image else { return }
        let export = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        export.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(export, animated: true, completion: nil)
    }
    
}

