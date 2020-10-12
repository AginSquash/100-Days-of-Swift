//
//  scripts.swift
//  Extension
//
//  Created by Vlad Vrublevsky on 10.10.2020.
//

import Foundation

struct scriptSave: Codable {
    let url: String
    let code: String
}

struct scripts: Codable {
    var saved: [scriptSave]
}
