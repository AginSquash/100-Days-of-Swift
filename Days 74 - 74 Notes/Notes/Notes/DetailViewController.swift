//
//  DetailViewController.swift
//  Notes
//
//  Created by Vlad Vrublevsky on 20.10.2020.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var noteName: UITextField!
    @IBOutlet var text: UITextView!
    
    var notes: [Note]?
    var currentNote: Note?
    
    var callback: ((String, String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
            
        noteName.text = currentNote?.name
        text.text = currentNote?.text
        
        text.becomeFirstResponder()
    }
    
    @objc func share() {
        let avc = UIActivityViewController(activityItems: ["Note name: \(noteName.text ?? "No name")\nText: \(text.text ?? "")"], applicationActivities: nil)
        present(avc, animated: true, completion: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            text.contentInset = .zero
        } else {
            text.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        text.scrollIndicatorInsets = text.contentInset

        let selectedRange = text.selectedRange
        text.scrollRangeToVisible(selectedRange)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        callback?(self.noteName.text ?? "No name", self.text.text)
        print("viewDidDisappear")
        super.viewDidDisappear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
