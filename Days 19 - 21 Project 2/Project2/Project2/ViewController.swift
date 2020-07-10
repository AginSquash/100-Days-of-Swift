//
//  ViewController.swift
//  Project2
//
//  Created by Vlad Vrublevsky on 10.07.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var totalAnswered = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = "Find " + countries[correctAnswer].uppercased() + "! Now your score is \(score)"
        
        totalAnswered += 1
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        totalAnswered += 1
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            message = ""
        } else {
            title = "Wrong"
            score -= 1
            message = "That’s the flag of \(countries[sender.tag]) \n"
        }
        
        if totalAnswered == 10 {
            message += "Your FINAL score is \(score)"
            score = 0
            totalAnswered = 0
        } else {
            message += "Your score is \(score)"
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert in }))
        present(ac, animated: true)
    }
    
}

