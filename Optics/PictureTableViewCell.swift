//
//  PictureTableViewCell.swift
//  Optics
//
//  Created by Jérémy Smith on 22/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var pictureTimeAgo: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
