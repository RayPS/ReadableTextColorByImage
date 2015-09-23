//
//  ViewController.swift
//  ReadableTextColorByImage
//
//  Created by Ray on 9/23/15.
//  Copyright © 2015 RayPS. All rights reserved.
//


import UIKit
//import QuartzCore

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var screenButton: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    
    
    
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        var image: UIImage!
        
        // fetch the selected image
        if imagePicker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        selectedImage = image
        
        // Do something about image by yourself
        
        screenButton.setBackgroundImage(image, forState: UIControlState.Normal)
        
        // dissmiss the image picker controller window
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        if isLightColor(averageColor()) {
            screenButton.tintColor = UIColor.blackColor()
        } else {
            screenButton.tintColor = UIColor.whiteColor()
        }
        
    }
    
    func averageColor() -> UIColor {
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context: CGContextRef = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, info.rawValue)!
        
        if let selectedImage = selectedImage {
            CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), selectedImage.CGImage)
        }
        
        
        if rgba[3] > 0 {
            
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
            
        } else {
            
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
    
    func isLightColor(color: UIColor) -> Bool{
        
        var white: CGFloat = 0.0
        color.getWhite(&white, alpha: nil)
        if white >= 0.9 { return true }
        else { return false }
    }
    
    
    
    @IBAction func myButtonDidTouched(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
}
