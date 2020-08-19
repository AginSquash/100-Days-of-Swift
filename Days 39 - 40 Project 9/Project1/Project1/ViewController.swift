//
//  ViewController.swift
//  Project1
//
//  Created by Vlad Vrublevsky on 09.07.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    self.pictures.append(item)
                }
            }
            self.pictures.sort(by: { $0 < $1 })
            print(self.pictures)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "Picture \(indexPath.row + 1) of \(pictures.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imageName = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareApp() {
        let vc = UIActivityViewController(activityItems: ["Download this app ''Projcet2''!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

