//
//  AddMealPhotoViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 7/5/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse

class AddMealPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView = UIImageView()

    @IBAction func takePhoto(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = false
            presentViewController(picker, animated: true, completion: nil)
        
    }
}
        
    @IBAction func addFromGallery(sender: AnyObject) {
        
        var imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
 
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
        
        let imageData = UIImagePNGRepresentation(image)
        //TODO: Set Name of imagefile??
        let imageFile:PFFile = PFFile(data: imageData)
        
        var userPhoto = PFObject(className:"FoodDiaryEntries")
   //     userPhoto["imageName"] = "Name of Image"
        userPhoto["imageFile"] = imageFile
        userPhoto["mealName"] = ""
        userPhoto["location"] = ""
        userPhoto["timestamp"] = ""
        userPhoto["wasEaten"] = true
        userPhoto["user"] = "chris test"
        userPhoto["otherDiners"] = ""
        userPhoto["mood"] = ""
        userPhoto["Notes"] = ""
        userPhoto["calories"] = 0
        userPhoto["energyLevel"] = 0
        userPhoto["enjoymentScore"] = 0
        userPhoto["gramsCarbs"] = 0
        userPhoto["gramsFat"] = 0
        userPhoto["gramsProtein"] = 0
        userPhoto["healthScore"] = 0
        userPhoto.saveInBackground()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
