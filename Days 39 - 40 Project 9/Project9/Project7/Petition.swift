//
//  Petition.swift
//  Project7
//
//  Created by Vlad Vrublevsky on 26.07.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
    
    func contain(_ text: String) -> Bool{
        title.contains(text) || body.contains(text)
    }
}
