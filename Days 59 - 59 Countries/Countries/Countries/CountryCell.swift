//
//  CountryCell.swift
//  Countries
//
//  Created by Vlad Vrublevsky on 11.09.2020.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var no_img_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
