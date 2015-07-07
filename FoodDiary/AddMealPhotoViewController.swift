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
            picker.allowsEditing = true
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
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        imageView.image = image
        makeRoomForImage()
        
        dismissViewControllerAnimated(true, completion: nil)
        
        let imageData = UIImagePNGRepresentation(image)
        //TODO: Set Name of imagefile??
        let imageFile:PFFile = PFFile(data: imageData)
        
        var userPhoto = PFObject(className:"FoodDiaryEntries")
   //     userPhoto["imageName"] = "Name of Image"
        userPhoto["imageFile"] = imageFile
        userPhoto["mealName"] = ""
        userPhoto["location"] = ""
        userPhoto["timestamp"] = NSDate()
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
        userPhoto["timezone"] = NSTimeZone.localTimeZone().abbreviation!
      /*  userPhoto["geoPointLocation"] = PFGeoPoint.geoPointForCurrentLocationInBackground as! PFGeoPoint */
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
    
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.scale > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.scale
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
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
