//
//  ViewController.swift
//  Countries
//
//  Created by Vlad Vrublevsky on 11.09.2020.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [CountryFULL]()
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
        cell.label.text = country.name.common
        
        if indexPath.row >= self.countries_flags.count {
            cell.flagImage.image = nil
            cell.no_img_label.isHidden = false
            return cell
        }
        
        if let image = countries_flags[indexPath.row] {
            cell.flagImage.image = image
            cell.flagImage.layer.cornerRadius = 5
            cell.flagImage.layer.borderColor = UIColor.gray.cgColor
            cell.flagImage.layer.borderWidth = 1
            cell.no_img_label.isHidden = true
        } else {
            cell.flagImage.image = nil
            cell.no_img_label.isHidden = false
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailView {
            let country = countries[indexPath.row]
            
            if indexPath.row < countries_flags.count && countries_flags[indexPath.row] != nil {
                vc.image = countries_flags[indexPath.row]
            }
            
            vc.text = "\(country.name.common)\nCaptal: \(country.capital.first ?? "???")"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func loadCountries() {
        let resource = Bundle.main.resourceURL!.appendingPathComponent("countries_flags150px.json")
        guard let fileURL = try? Data(contentsOf: resource) else {
            fatalError("fileURL is nil")
        }
        if let decoded = try? JSONDecoder().decode([CountryFULL].self, from: fileURL) {
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
            if let url = country.flag_img {
    
                let imageData = try? Data(contentsOf: url)
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

