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
    var allWords = [String]()
    var choosenWord = String()
    
    var usedButtons = [UIButton]()
    
    var score = 0 {
        didSet {
            ScoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        super.loadView()
        
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //buttonsView.backgroundColor = .red
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
                //charButton.backgroundColor = .green
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
        
        loadGame()
    }

    func loadGame() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = Bundle.main.url(forResource: "words", withExtension: "txt") {
                if let wordsContents = try? String(contentsOf: url) {
                    self.allWords = wordsContents.components(separatedBy: "\n")
                    
                    DispatchQueue.main.async {
                        self.newWord()
                    }
                }
            }
        }
    }
    
    func newWord() {
        self.choosenWord = self.allWords.randomElement() ?? "ERROR"
        self.WordLabel.text = String(repeating: "?", count: self.choosenWord.count)
        
        for btn in self.usedButtons {
            btn.isHidden = false
        }
    }
    
    
    @objc func wordChoosen(_ sender: UIButton) {
        guard let buttonLabel = sender.titleLabel?.text?.lowercased() else { return }
        
        var wordCopy = choosenWord
        var index = wordCopy.firstIndex(of: Character(buttonLabel))
        
        if index == nil {
            score -= 1
            let ac = UIAlertController(title: "Wrong letter", message: "Try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
        
        while index != nil {
            wordCopy.replaceSubrange(index!...index!, with: " ")
            self.WordLabel.text!.replaceSubrange(index!...index!, with: buttonLabel.uppercased())
            index = wordCopy.firstIndex(of: Character(buttonLabel))
            score += 1
        }
        
        sender.isHidden = true
        usedButtons.append(sender)
        
        if choosenWord == self.WordLabel.text?.lowercased() {
            let ac = UIAlertController(title: "Win!", message: "Yes, it's \(choosenWord)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New word!", style: .default, handler: { _ in self.newWord() }))
            present(ac, animated: true, completion: nil)
        }
    }

}

