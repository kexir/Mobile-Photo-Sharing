//
//  TableViewCell.swift
//  Mobile-Photo-Sharing
//
//  Created by LyuQi on 9/19/17.
//  Copyright © 2017 LyuQi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageName: UILabel!
    
    @IBOutlet weak var share: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
