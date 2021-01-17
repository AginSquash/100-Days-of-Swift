//
//  Pairs.swift
//  PairsGame
//
//  Created by Vlad Vrublevsky on 14.01.2021.
//

import Foundation

struct Pair: Codable, Equatable {
    var status: Int16 = 0
    let capital: String
    let country: String
    
    static func getExample() -> [Pair] {
        let pairs = [ Pair(capital: "Moscow", country: "Russia"), Pair(capital: "London", country: "Britan"), Pair(capital: "Minsk", country: "Belarus"),
                      Pair(capital: "Paris", country: "France"), Pair(capital: "Stockholm", country: "Sweden"), Pair(capital: "Warsaw", country: "Poland")
        ]
        return pairs
    }
    
    static func == (_ lhs: Pair, _ rhs: Pair) -> Bool {
        return (lhs.capital == rhs.capital)&&(lhs.country == rhs.country)
    }
}
