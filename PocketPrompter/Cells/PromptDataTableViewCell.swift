//
//  PromptDataTableViewCell.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 9/21/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class PromptDataTableViewCell: UITableViewCell {

    @IBOutlet weak var snapShotImageView: UIImageView!
    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var separatorLineView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
