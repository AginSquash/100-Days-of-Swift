//
//  ViewController.swift
//  Countries
//
//  Created by Vlad Vrublevsky on 11.09.2020.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()
    var countries_flags = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadCountries()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesReuse", for: indexPath) as? CountryCell ?? CountryCell()
        let country = countries[indexPath.row]
        cell.label.text = country.name_ru
        
        if indexPath.row >= self.countries_flags.count {
            return cell
        }
        
        if let image = countries_flags[indexPath.row] {
            cell.flagImage.image = image
        }
        return cell
    }

    func loadCountries() {
        let resource = Bundle.main.resourceURL!.appendingPathComponent("ISO3166_RU.json")
        guard let fileURL = try? Data(contentsOf: resource) else {
            fatalError("fileURL is nil")
        }
        if let decoded = try? JSONDecoder().decode([Country].self, from: fileURL) {
            self.countries = decoded
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.loadImages()
        }
    }
    
    func loadImages() {
        var i = 0
        for country in countries {
            if let url = country.flag_url {
                
                print("DEBUG: start loadImages")
                var str = url.absoluteString
                str = "https:" + str
                
                str = str.replacingOccurrences(of: "22px", with: "150px")
                
                let imageData = try? Data(contentsOf: URL(string: str)!)
                if let image = imageData {
                    self.countries_flags.append(UIImage(data: image))
                } else {
                    self.countries_flags.append(nil)
                }
               
                
                if i % 3 == 0 || i+1 == countries.count
                {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                i += 1
            } else {
                 self.countries_flags.append(nil)
            }
        }
    }
}

