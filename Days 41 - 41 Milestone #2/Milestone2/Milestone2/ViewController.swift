//
//  ViewController.swift
//  Milestone2
//
//  Created by Vlad Vrublevsky on 19.08.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var ScoreLabel: UILabel!
    @IBOutlet var WordLabel: UILabel!
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func loadView() {
        super.loadView()
        
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = .red
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            
            buttonsView.widthAnchor.constraint(equalToConstant: 360),
            buttonsView.heightAnchor.constraint(equalToConstant: 420),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
         
        let width = 90
        let height = 60
        
        var charNumber = 0
        for row in 0 ..< 7 {
            for col in 0 ..< 4 {
                guard charNumber < letters.count else { return }
                
                let charButton = UIButton(type: .system)
                charButton.setTitle(letters[charNumber], for: .normal)
                charButton.backgroundColor = .green
                charButton.layer.borderWidth = 1
                charButton.layer.borderColor = UIColor.gray.cgColor
                
                var frame = CGRect()
                if row == 6 {
                     frame = CGRect(x: col * width + width, y: row * height, width: width, height: height)
                } else {
                     frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                }
                charButton.frame = frame
                
                charButton.addTarget(self, action: #selector(wordChoosen), for: .touchUpInside)
                
                buttonsView.addSubview(charButton)
                
                charNumber += 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        }

    @objc func wordChoosen(_ sender: UIButton) {
        
    }

}

