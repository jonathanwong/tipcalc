//
//  ThemeTableViewCell.swift
//  tipcalc
//
//  Created by Jonathan Wong on 3/2/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var themeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
