//
//  CommentTableViewCell.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var authorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
