//
//  MovieViewCell.swift
//  Flickr
//
//  Created by Viet Dang Ba on 2/16/17.
//  Copyright © 2017 Viet Dang. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTiltle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
