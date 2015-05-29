//
//  ViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 5/15/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var foodImages: [String] = ["ChipotleChickenSalad.png", "biriteicecream.jpg"]
    var mealNameData: [String] = ["Chipotle Chicken Salad", "Ice Cream Sundae"]
    var locationLabelData: [String] = ["Sprig", "Bi-Rite Creamery"]
    var scoreLabelData: [String] = ["90%", "20%"]
    var dateLabelData: [String] = ["May 29, 2015 12:34 PM", "May 28, 2015 9:33 PM"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println("Changing text in println again.")
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: colViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as colViewCell
        cell.mealNameLblCell.text = mealNameData[indexPath.row]
        cell.locationNameLblCell.text = locationLabelData[indexPath.row]
        cell.mealScoreLblCell.text = scoreLabelData[indexPath.row]
        cell.timestampLblCell.text = dateLabelData[indexPath.row]
        cell.imgCell.image = UIImage(named: foodImages[indexPath.row])
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Cell \(indexPath.row) selected")
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



