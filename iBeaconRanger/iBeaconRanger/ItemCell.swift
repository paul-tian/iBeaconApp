//
//  ItemCell.swift
//  iBeaconRanger
//
//  Created by Paul Tian
//  Copyright © 2018 Paul Tian. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

