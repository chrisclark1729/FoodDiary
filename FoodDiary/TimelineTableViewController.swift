//
//  TimelineTableViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 6/7/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import MobileCoreServices

class TimelineTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    var dataManager = DataManager()
    var dateFormatter = DateFormatter()
    var dayFormatter = DateFormatter()
    var timeFormatter = DateFormatter()
    var meals:[FoodDiaryEntry]?
    var rowToDelete: IndexPath?
    var imageView = UIImageView()
    var locationNameSuggestions:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataManager.delegate = self

        if PFUser.current() != nil {
          self.dataManager.loadTimelineData()
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dayFormatter.dateFormat = "EE, h:mm a"
        timeFormatter.dateFormat = "h:mm a"
        NotificationCenter.default.addObserver(self, selector: #selector(TimelineTableViewController.userDidLogIn(_:)), name: NSNotification.Name(rawValue: "userDidLogIn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TimelineTableViewController.archiveMeal(_:)), name: NSNotification.Name(rawValue: "archiveMealNotification"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func userDidLogIn(_ notification: Notification) {
        self.dataManager.loadTimelineData()
    }
    
    func archiveMeal(_ notification: Notification) {
        let mealToArchive: FoodDiaryEntry = notification.object as! FoodDiaryEntry
        var indexToArchive: Int?
        for (index, element) in meals!.enumerated() {
            print("Item \(index): \(element)")
            if element == mealToArchive {
                indexToArchive = index
                break
            }
                    }
        self.meals!.remove(at: indexToArchive!)
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        LocationManagerViewController.sharedLocation.refreshLocation()
        self.locationNameSuggestions = FoodDiaryEntry.getLocationSuggestions(PFGeoPoint(location: LocationManagerViewController.sharedLocation.lastKnownLocation))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   func deleteFoodDiaryEntry() {
        let alert: UIAlertView = UIAlertView()
        /*
            if let superview = button.superview {
                if let cell = superview.superview as? TimelineTableViewCell {
                    let indexPath = self.tableView.indexPath(for: cell)
                    self.rowToDelete = indexPath
                }
        } */
        
        alert.title = "Delete"
        alert.message = "Are you sure you want to permanently delete this entry?"
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        alert.delegate = self  // set the delegate here
        alert.show()
    
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitle(at: buttonIndex)
        print("\(buttonTitle!) pressed")
        if buttonTitle == "Yes" {
            // TODO: Figure out how I know what the current food Diary Entry Id is?
            let entry = self.meals![(self.rowToDelete! as NSIndexPath).row]
            entry.deleteFromBackEnd()
            self.meals!.remove(at: (self.rowToDelete! as NSIndexPath).row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let meals = self.meals {
            return meals.count
        } else {
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 78
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as! TimelineTableViewCell
        
        let meal = meals![(indexPath as NSIndexPath).row]
        
        var mealImageFile:PFFile?
        mealImageFile = meal.imgURL as? PFFile
        
        if mealImageFile != nil {
            mealImageFile!.getDataInBackground {
                (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.mealImage.image = image
                    }
                }
            }
        } else {
            print("mealImageFile is nil.")
        }
        
        let calories = NSString(format: "%.0f", meal.calories)
        
        cell.mealName.text = meal.mealName
        cell.mealLocationName.text = meal.locationName
        cell.mealDate.text = dayFormatter.string(from: meal.timestamp as Date)
        cell.calorieLabel.text = calories as String
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)  {
    if editingStyle == .delete {
        
    // Delete the row from the data source
        self.deleteFoodDiaryEntry()
    tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            
            let destination = segue.destination as! ViewMealDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let meal = meals![(selectedIndexPath! as NSIndexPath).row]
            
            destination.foodDiaryEntry = meal
            
        }
        
    }
    
    func hideAllArchived() {
        if let meals = self.meals {
            var archived = [FoodDiaryEntry]()
            
            for meal in meals {
                if !meal.isVisible {
                    archived.append(meal)
                }
            }
        }
    }

//MARK: Camera

    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoWithCameraButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
            
        } else {
            noCamera()
        }

    }
    
    
    @IBAction func addPhotoFromGalleryButtonPressed(_ sender: UIButton) {
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        // self.getCurrentLocationName()
        self.tableView.reloadData()
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        imageView.image = image
        makeRoomForImage()
        
        dismiss(animated: true, completion: nil)
        
        let imageData = image!.lowestQualityJPEGNSData
        let imageFile:PFFile = PFFile(data: imageData as Data)!
        
        let userPhoto = PFObject.createFoodDiaryEntryPFObject()
        
        userPhoto["imageFile"] = imageFile
        userPhoto["userId"] = PFUser.current()
        userPhoto["location"] = PFGeoPoint(location: LocationManagerViewController.sharedLocation.lastKnownLocation)
        if self.locationNameSuggestions.count > 0 {
            userPhoto["locationName"] = self.locationNameSuggestions[0]
        }
        userPhoto.saveInBackground()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if (imageView.image?.scale)! > CGFloat(0)  {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.scale
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRect.zero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
    }
    
    // MARK: - Location
    /*
     func getCurrentLocationName() {
     
     self.placesClient?.currentPlaceWithCallback({ (placeLikelihoods: GMSPlaceLikelihoodList?, error) -> Void in
     if error != nil {
     print("Current Place error: \(error!.localizedDescription)")
     return
     }
     
     for likelihood in placeLikelihoods!.likelihoods {
     if let likelihood = likelihood as? GMSPlaceLikelihood {
     let place = likelihood.place
     print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
     print("Current Place address \(place.formattedAddress)")
     print("Current Place attributions \(place.attributions)")
     print("Current PlaceID \(place.placeID)")
     }
     }
     })
     } */
 
}
