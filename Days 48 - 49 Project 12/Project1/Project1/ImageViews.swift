//
//  ImageViews.swift
//  Project1
//
//  Created by Vlad Vrublevsky on 24.08.2020.
//  Copyright © 2020 Vlad Vrublevsky. All rights reserved.
//

import UIKit

class ImageViews: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(imageName, forKey: "iamgeName")
        coder.encode(views, forKey: "views")
    }
    
    required init?(coder: NSCoder) {
        self.imageName = coder.decodeObject(forKey: "iamgeName") as? String ?? ""
        self.views = coder.decodeObject(forKey: "views") as? Int ?? 0
    }
    
    init(imageName: String) {
        self.imageName = imageName
        views = 0
    }
    
    var imageName: String
    var views: Int
}
