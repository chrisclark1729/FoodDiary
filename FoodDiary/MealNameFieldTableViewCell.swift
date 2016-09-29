//
//  MealNameFieldTableViewCell.swift
//  FoodDiary
//
//  Created by Chris Clark on 11/23/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit

class MealNameFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealNameField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
