//
//  DetailView.swift
//  Countries
//
//  Created by Vlad Vrublevsky on 14.09.2020.
//

import UIKit

class DetailView: UIViewController {

    @IBOutlet var uiimageview: UIImageView!
    @IBOutlet var label: UILabel!
    
    var image: UIImage?
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.uiimageview.image = image
        self.label.text = text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
