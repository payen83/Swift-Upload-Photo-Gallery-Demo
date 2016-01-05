//
//  LoadImageTableViewCell.swift
//  PhotoSaveDemo
//
//  Created by Ferdy Fauzi on 29/12/2015.
//  Copyright © 2015 Ferdy Fauzi. All rights reserved.
//

import UIKit

class LoadImageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var myImageList: UIImageView!
    
    @IBOutlet weak var myText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
