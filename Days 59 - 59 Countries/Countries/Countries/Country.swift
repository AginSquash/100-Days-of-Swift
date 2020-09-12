//
//  Country.swift
//  Countries
//
//  Created by Vlad Vrublevsky on 11.09.2020.
//

import Foundation
import UIKit

struct Country: Codable {
    let flag_url: URL?
    let name_ru: String
    let iso_code2: String
    let iso_code3: String
}

