//
//  Person.swift
//  Project10
//
//  Created by Vlad Vrublevsky on 21.08.2020.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
