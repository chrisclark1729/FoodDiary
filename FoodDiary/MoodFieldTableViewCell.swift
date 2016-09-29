//
//  MoodFieldTableViewCell.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/2/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit

class MoodFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var moodField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
