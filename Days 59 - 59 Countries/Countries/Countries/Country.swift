//
//  Country.swift
//  Countries
//
//  Created by Vlad Vrublevsky on 11.09.2020.
//

import Foundation
import UIKit

/// OLD
struct Country: Codable {
    let flag_url: URL?
    let name_ru: String
    let iso_code2: String
    let iso_code3: String
}
///

struct CountryFULL: Codable {
    let name: c_name
    let flag_img: URL?
    let tld: [String]
    let cca2: String
    let ccn3: String
    let cca3: String
    let cioc: String
    let currencies: [String: c_currencies]
    let callingCodes: [String]
    let capital: [String]
    let altSpellings: [String]
    let region: String
    let subregion: String
    let demonyms: c_demonyms
    let landlocked: Bool
    let languages: [String: String]
    let latlng: [Double: Double]
    let translations: c_translations
    let borders: [String]
    let area: Double
    let flag: String
}


struct c_name: Codable {
    let common: String
    let official: String
    let native: [String: c_name_native]
}

struct c_name_native: Codable {
    let official: String
    let common: String
}

struct c_currencies: Codable {
    let name: String
    let symbol: String
}

struct c_demonyms: Codable {
    let eng: c_demonyms_lang
    let fra: c_demonyms_lang
}

struct c_demonyms_lang: Codable {
    let f: String
    let m: String
}

struct c_translations: Codable {
    let deu: c_name_native
    let est: c_name_native
    let ita: c_name_native
    let fra: c_name_native
    let rus: c_name_native
    let spa: c_name_native
}
