//
//  ViewController.swift
//  MemeMev1.0
//
//  Created by Robert Coffey on 06/12/2015.
//  Copyright © 2015 Robert Coffey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var takePhoto: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
//    let topTextDelegate = UITextFieldDelegate()
//    let bottomTextFieldDelegate = UITextFieldDelegate()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3, NSBackgroundColorAttributeName: UIColor.clearColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide photo button if no camera source available
        takePhoto.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        topText.delegate = self
        bottomText.delegate = self
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.hidden = true
        bottomText.hidden = true
        topText.text = "TOP"
        topText.textAlignment = .Center
        bottomText.text = "BOTTOM"
        bottomText.textAlignment = .Center
        
        shareButton.enabled = false

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        let keyboardHeight = keyboardSize.CGRectValue().height
        
        if bottomText.isFirstResponder() && view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        let keyboardHeight = keyboardSize.CGRectValue().height
        
        if bottomText.isFirstResponder() && view.frame.origin.y != 0 {
            view.frame.origin.y += keyboardHeight
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
  
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFill
            imagePickerView.image = image
            topText.hidden = false
            bottomText.hidden = false
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
           textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
/*        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
*/    }
    
/*    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        <#code#>
    }
*/
    
    func generateMemedImage() -> UIImage {
        
        //Hide tool bar and navbar
        toolBar.hidden = true
        navBar.hidden = true
        
        //Render view of and image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        //Present tool bar and nav bar again
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    

    @IBAction func takePhoto(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        print("Arrived in pickAnImage function")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }


    @IBAction func bottomText(sender: UITextField) {
        "Arrived in bottom text function"
    }
    
    @IBAction func shareImage(sender: UIBarButtonItem) {
        print("Arrived in share function")
        let memedImage = generateMemedImage()
        var meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!
            , memedImage: memedImage)
        print (memedImage)
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler(
        
    }
}

