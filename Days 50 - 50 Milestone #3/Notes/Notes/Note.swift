//
//  Note.swift
//  Notes
//
//  Created by Vlad Vrublevsky on 25.08.2020.
//

import UIKit

class Note: NSObject, Codable {
    var image: String
    var caption: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}
