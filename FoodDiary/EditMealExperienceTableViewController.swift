//
//  EditMealExperienceTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 8/9/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit

class EditMealExperienceTableViewController: UITableViewController {
    
    var foodDiaryEntry: FoodDiaryEntry?

    @IBOutlet weak var editMealEnjoymentScoreSlider: UISlider!
    @IBOutlet weak var editEnergyLevelSlider: UISlider!
    @IBOutlet weak var editMealHealthScoreSlider: UISlider!
    
    
    @IBOutlet weak var enjoymentScoreLabel: UILabel!
    @IBOutlet weak var energyLevelLabel: UILabel!
    @IBOutlet weak var healthScoreLabel: UILabel!
    
    
    @IBAction func enjoymentScoreSlider(_ sender: AnyObject) {
        
        let currentEnjoymentScore = NSString(format: "%.1f",self.editMealEnjoymentScoreSlider.value)
        enjoymentScoreLabel.text = "Enjoyment Score: \(currentEnjoymentScore)/5.0"
    }
    @IBAction func energyLevelSlider(_ sender: AnyObject) {
        let currentEnergyLevel = NSString(format: "%.1f", self.editEnergyLevelSlider.value)
        energyLevelLabel.text = "Energy Level: \(currentEnergyLevel)/5.0"
        
    }
    
    @IBAction func healthScoreSlider(_ sender: AnyObject) {
        let currentHealthScore = NSString(format: "%.1f",self.editMealHealthScoreSlider.value)
        healthScoreLabel.text = "Health Score: \(currentHealthScore)/5.0"
        
    }
    
    
    @IBAction func saveMealExperience(_ sender: AnyObject) {
        
        
        
        self.foodDiaryEntry?.enjoymentScore = self.editMealEnjoymentScoreSlider.value
        self.foodDiaryEntry?.energyLevel = self.editEnergyLevelSlider.value
        self.foodDiaryEntry?.healthScore = self.editMealHealthScoreSlider.value
        
        foodDiaryEntry!.save()
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSliders()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func initSliders() {
        if let editEnergyLevel = self.editEnergyLevelSlider,
        let editMealEnjoymentScore = self.editMealEnjoymentScoreSlider,
        let editMealHealthScore = self.editMealHealthScoreSlider {
            
            if let entry = foodDiaryEntry {
                
                editEnergyLevel.value = Float(entry.energyLevel)
                editMealEnjoymentScore.value = Float(entry.enjoymentScore)
                editMealHealthScore.value = Float(entry.healthScore)
            }
            else {
                print("No Food Entry")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
