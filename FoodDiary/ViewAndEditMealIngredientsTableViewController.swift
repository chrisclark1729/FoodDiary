//
//  ViewAndEditMealIngredientsTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 10/13/15.
//  Copyright © 2015 Chris Clark. All rights reserved.
//

import UIKit
//import Parse

class ViewAndEditMealIngredientsTableViewController: UITableViewController {
    

    @IBOutlet var ingredientList: UITableView!
    
    let textCellIdentifier = "IngredientCell"
    var foodDiaryEntry: FoodDiaryEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientList.delegate = self
        ingredientList.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.foodDiaryEntry?.populateIngredientDetails()
        self.foodDiaryEntry?.populateIngredients()
        self.ingredientList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Session.sharedInstance.currentSelectedFoodDiaryDetail = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.foodDiaryEntry!.ingredientDetails.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = (indexPath as NSIndexPath).row
        let ingredientDetail = self.foodDiaryEntry!.ingredientDetails[row]
        let ingredientId = ingredientDetail.ingredientId
        do {
          try ingredientId?.fetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        let ingredientName = ingredientId!["ingredientName"] as? String
        let ingredientUnitOfMeasurement = ingredientId!["unitOfMeasurement"] as? String
        let calories = ingredientId!["calories"] as? Float
        let totalCalories = calories! * ingredientDetail.quantity!
        var unitOfMeasurementSeparator = "): "
        
        if ingredientDetail.quantity! <= 1 {
            unitOfMeasurementSeparator = "s): "
        
        }
        
        cell.textLabel?.text = ingredientName! + " (" + (NSString(format: "%.1f",ingredientDetail.quantity!) as String) + " " + ingredientUnitOfMeasurement! + unitOfMeasurementSeparator + (NSString(format: "%.0f",totalCalories) as String) + " cal."
        
        return cell
    }
  
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editMealExperience" {
            let destination = segue.destinationViewController as! EditMealExperienceTableViewController
            
            destination.foodDiaryEntry = self.foodDiaryEntry
        }
    } */


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let foodDiaryDetail = self.foodDiaryEntry!.ingredientDetails[(indexPath as NSIndexPath).row]
            self.foodDiaryEntry?.deleteFoodDiaryDetail(foodDiaryDetail)
            self.foodDiaryEntry!.ingredientDetails.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodDiaryDetail = self.foodDiaryEntry!.ingredientDetails[(indexPath as NSIndexPath).row]
        Session.sharedInstance.currentSelectedFoodDiaryDetail = foodDiaryDetail
        Session.sharedInstance.currentIngredient = foodDiaryDetail.ingredientId
        print("selected ingredient \(foodDiaryDetail)")
      
        self.performSegue(withIdentifier: "editIngredientQuantity", sender: self)
       // let destination = segue.destinationViewController as! IngredientAddTableViewController
        
     //   destination.foodDiaryEntry = self.foodDiaryEntry

    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
