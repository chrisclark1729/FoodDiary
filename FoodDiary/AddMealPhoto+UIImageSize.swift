//
//  AddMealPhoto+UIImageSize.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/30/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import Foundation
//import Parse
import UIKit

extension UIImage {
    var highestQualityJPEGNSData:Data { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData:Data    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGNSData:Data  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData:Data     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData:Data  { return UIImageJPEGRepresentation(self, 0.0)! }
}
