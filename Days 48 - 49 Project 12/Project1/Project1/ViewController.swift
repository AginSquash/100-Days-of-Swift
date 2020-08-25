//
//  ViewController.swift
//  Project1
//
//  Created by Vlad Vrublevsky on 09.07.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var imageViews = [ImageViews]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        
        if let savedImages = UserDefaults.standard.object(forKey: "imageViews") as? Data{
            if let decodedIV = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedImages) as? [ImageViews] {
                    imageViews = decodedIV
            }
        }
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                if imageViews.first(where: { $0.imageName == item }) == nil {
                    self.imageViews.append(ImageViews(imageName: item))
                }
            }
        }
        
        imageViews.sort(by: { $0.imageName < $1.imageName })
        save()
        print(imageViews)
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageViews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "Picture \(indexPath.row + 1) of \(imageViews.count). Views: \(imageViews[indexPath.row].views)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = imageViews[indexPath.row].imageName
            vc.imageName = "Picture \(indexPath.row + 1) of \(imageViews.count)"
            imageViews[indexPath.row].views += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareApp() {
        let vc = UIActivityViewController(activityItems: ["Download this app ''Projcet2''!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: imageViews, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "imageViews")
        }
    }
}

