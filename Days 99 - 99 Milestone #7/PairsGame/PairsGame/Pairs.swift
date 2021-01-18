//
//  Pairs.swift
//  PairsGame
//
//  Created by Vlad Vrublevsky on 14.01.2021.
//

import Foundation

struct Pair: Codable, Equatable {
    var status: Int16 = 0
    let element1: String
    let element2: String
    
    static func getExample() -> [Pair] {
        let pairs = [ Pair(element1: "Moscow", element2: "Russia"), Pair(element1: "London", element2: "Britan"), Pair(element1: "Minsk", element2: "Belarus"),
                      Pair(element1: "Paris", element2: "France"), Pair(element1: "Stockholm", element2: "Sweden"), Pair(element1: "Warsaw", element2: "Poland")
        ]
        return pairs
    }
    
    static func == (_ lhs: Pair, _ rhs: Pair) -> Bool {
        return (lhs.element1 == rhs.element1)&&(lhs.element2 == rhs.element2)
    }
}
