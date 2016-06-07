//
//  BaseEntity.swift
//  FoodDiary
//
//  Created by Chris Clark on 12/1/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class BaseEntity: AnyObject {
    var entity:PFObject
    init(entity: PFObject) {
        self.entity = entity
    }
    
    func save() {
        do {
          try self.entity.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }

}
