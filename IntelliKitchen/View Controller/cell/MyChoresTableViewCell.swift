//
//  MyChoresTableViewCell.swift
//  IntelliKitchen_Myfood
//
//  Created by D.WANG on 5/24/20.
//  Copyright © 2020 D.WANG. All rights reserved.
//

import UIKit

class MyChoresTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var lastDoneLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
