//
//  DetailViewController.swift
//  Challenge23
//
//  Created by Vlad Vrublevsky on 11.07.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: imageName!)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
    }

    @objc func shareFlag() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1.0) else {
            print("No image")
            return
        }
        guard let name = imageName?.uppercased() else {
            print("No name")
            return
        }
        let avc = UIActivityViewController(activityItems: [image, name], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
    
}
