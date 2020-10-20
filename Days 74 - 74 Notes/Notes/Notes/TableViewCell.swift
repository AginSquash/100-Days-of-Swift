//
//  TableViewCell.swift
//  Notes
//
//  Created by Vlad Vrublevsky on 20.10.2020.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var previewImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        previewImage.image = UIImage(systemName: "record.circle")
        previewImage.tintColor = .purple
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
