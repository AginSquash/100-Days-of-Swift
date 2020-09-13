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
        print(decoded)
    } catch {
        print(error.localizedDescription)
    }
}

func main() {
    let resource = Bundle.main.resourceURL!
    guard let fileURL1 = try? Data(contentsOf: resource.appendingPathComponent("ISO3166_RU.json")) else {
        fatalError("fileURL is nil")
    }
    var isoCountries = try! JSONDecoder().decode([Country_ISO3166_RU].self, from: fileURL1)
        
    guard let fileURL2 = try? Data(contentsOf: resource.appendingPathComponent("countries.json")) else {
        fatalError("fileURL is nil")
    }
    
    var countriesFull = try! JSONDecoder().decode([Country].self, from: fileURL2)

    var newCountries = [CountryWithFlagIMG]()
    for c in countriesFull {
        if let c_withFlagIMG = isoCountries.first(where: { $0.iso_code3 == c.cca3 }) {
            
            var flag_url: String = ""
            
            if c_withFlagIMG.flag_url != nil {
                flag_url = c_withFlagIMG.flag_url!.absoluteString
                flag_url = "https:" + flag_url
                flag_url = flag_url.replacingOccurrences(of: "22px", with: "128px")
            }
            
            let newC = CountryWithFlagIMG(name: c.name, flag_img: URL(string: flag_url), tld: c.tld, cca2: c.cca2, ccn3: c.ccn3, cca3: c.cca3, cioc: c.cioc, currencies: c.currencies, callingCodes: c.callingCodes, capital: c.capital, altSpellings: c.altSpellings, region: c.region, subregion: c.subregion, demonyms: c.demonyms, landlocked: c.landlocked, languages: c.languages, latlng: c.latlng, translations: c.translations, borders: c.borders, area: c.area, flag: c.flag)
            
            newCountries.append(newC)
            isoCountries.removeAll(where: { $0.iso_code3 == c.cca3 })
        }
    }
    
    if let encoded = try? JSONEncoder().encode(newCountries) {
        do {
            try encoded.write(to: resource.appendingPathComponent("countriesNew.json    "))
        } catch {
            print(error.localizedDescription)
        }
    }
}

main()
