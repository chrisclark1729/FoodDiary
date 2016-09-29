//
//  AddMealPhotoViewController.swift
//  FoodDiary
//
//  Created by Chris Clark on 7/5/15.
//  Copyright (c) 2015 Chris Clark. All rights reserved.
//

import UIKit
import MobileCoreServices
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//import Parse
//import GoogleMaps

class AddMealPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView = UIImageView()
 //   var placesClient: GMSPlacesClient?
    var locationNameSuggestions:[String] = []
    var foodDiaryEntry: FoodDiaryEntry?
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: AnyObject) {
        
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
        
    @IBAction func addFromGallery(_ sender: AnyObject) {
        
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
       // self.getCurrentLocationName()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManagerViewController.sharedLocation.refreshLocation()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManagerViewController.sharedLocation.refreshLocation()
        self.locationNameSuggestions = FoodDiaryEntry.getLocationSuggestions(PFGeoPoint(location: LocationManagerViewController.sharedLocation.lastKnownLocation))
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
