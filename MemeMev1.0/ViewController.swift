//
//  ViewController.swift
//  MemeMev1.0
//
//  Created by Robert Coffey on 06/12/2015.
//  Copyright © 2015 Robert Coffey. All rights reserved.
//

import UIKit


struct Meme {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var takePhoto: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    //Define default textfield parameters
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3, NSBackgroundColorAttributeName: UIColor.clearColor()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide photo button if no camera source available
        takePhoto.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Establish current class as delegate for text field objects
        topText.delegate = self
        bottomText.delegate = self
        
        //Set initial view parameters
        setFirstView()
        view.backgroundColor = UIColor.darkGrayColor()
    }
    
    
    func setFirstView() {
        //Set characteristics of text fields
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        //topText.size
        bottomText.textAlignment = .Center
        
        //Create initial text
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        //Hide share button until image is selected
        shareButton.enabled = false
        
        //Reset image
        imagePickerView.image = nil
        
        return
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Subscriber to notifications from keyboard object
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe to notifications from keyboard object
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        //Receive notifications when keyboard is shown and removed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        //Cancel notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        //Get geometric info regarding keyboard size
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        let keyboardHeight = keyboardSize.CGRectValue().height
        
        //If editing is started in bottom textfield, frame shall be moved up to avoid being covered by the keyboard, if not already moved up.
        if bottomText.isFirstResponder() && view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        //Get dictionary of info related to the keyboard notificaton
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        let keyboardHeight = keyboardSize.CGRectValue().height
        
        //If editing is stopped in bottom textfield, frame is moved back down as keyboard is removed, if frame not already lowered.
        if bottomText.isFirstResponder() && view.frame.origin.y != 0 {
            view.frame.origin.y += keyboardHeight
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        //Assign image from image picker to this class, sizing it to fill the available screen size. Share button is enabled and picker controller is dismissed.
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Resign first responsder, when text field is returned.
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Only clear text when editing for the first time
        if textField.text == "TOP" || textField.text == "BOTTOM" {
           textField.text = ""
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Increases width of textfield as user types each character and recenters textfield. This ensures user can continue to see all text whilst typing.
        if textField.frame.size.width <= view.frame.size.width {
                textField.frame.size.width += 20
                textField.frame.origin.x -= 10
        }
        return true
    }
    
    
    func generateMemedImage() -> UIImage {
        //Hide tool bar and navbar
        toolBar.hidden = true
        navBar.hidden = true
        
        //Render view as an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Present tool bar and nav bar again
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(memedImage: UIImage) {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!
            , memedImage: memedImage)
    }
    
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        //Instantiate image picker controller, allow the current class to be its delegate, use the Camera as the source and present the view controller.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        //Instantiate image picker controller, allow the current class to be its delegate, use the Photolibrary as the source and present the view controller.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func bottomText(sender: UITextField) {
        //Needed to secure correct functioning of BottomText notification
    }
  
    
    @IBAction func shareImage(sender: UIBarButtonItem) {
        //Generate the memed image and instantiate the meme class object with image, text and memed image
        let memedImage = generateMemedImage()
        //Instantiate the activity controller with the memedImage and present the controller
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        //activityController.completionWithItemsHandler(
        
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        //Reset screen to initial parameters
        setFirstView()
    }
    
}

