//
//  DefaultTipTableViewCell.swift
//  tipcalc
//
//  Created by Jonathan Wong on 3/2/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class DefaultTipTableViewCell: UITableViewCell {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
