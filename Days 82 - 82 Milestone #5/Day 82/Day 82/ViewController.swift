//
//  ViewController.swift
//  Day 82
//
//  Created by Vlad Vrublevsky on 11.11.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var text: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.text.bounceOut(duration: 5)
        
        5.times {
            print("Go!")
        }
    }


}

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            //self.contentScaleFactor = 0.0001
            //self.sizeThatFits(0.0001)
            self.frame.size.height *= 0.000001
            self.frame.size.width *= 0.000001
            self.backgroundColor = .red
            self.tintColor = .blue
        }
    }
}

extension Int {
    func times(_ toDo: (()->Void)) {
        for _ in 0..<self {
            toDo()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        let indexOpt = self.firstIndex(of: item)
        guard let index = indexOpt else { return }
        self.remove(at: index)
    }
}
