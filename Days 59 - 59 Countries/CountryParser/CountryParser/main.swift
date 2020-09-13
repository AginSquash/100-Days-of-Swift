//
//  main.swift
//  CountryParser
//
//  Created by Vlad Vrublevsky on 13.09.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import Foundation

func loadCountries1() {
    let resource = Bundle.main.resourceURL!.appendingPathComponent("ISO3166_RU.json")
    print("URL: \(resource)")
    guard let fileURL = try? Data(contentsOf: resource) else {
        fatalError("fileURL is nil")
    }
    if let decoded = try? JSONDecoder().decode([Country_ISO3166_RU].self, from: fileURL) {
        
        print(decoded)
    }
}

func loadCountries2() {
    let resource = Bundle.main.resourceURL!.appendingPathComponent("countries.json")
    guard let fileURL = try? Data(contentsOf: resource) else {
        fatalError("fileURL is nil")
    }
    
    do {
        let decoded = try JSONDecoder().decode([Country].self, from: fileURL)
        
    } catch {
        print(error.localizedDescription)
    }
}

func main() {
    loadCountries2()
}

main()
