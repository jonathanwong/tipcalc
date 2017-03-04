//
//  LocaleTableViewCell.swift
//  tipcalc
//
//  Created by Jonathan Wong on 3/3/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class LocaleTableViewCell: UITableViewCell {

    @IBOutlet weak var localeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
