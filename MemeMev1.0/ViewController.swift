//
//  ViewController.swift
//  MemeMev2.0
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
    @IBOutlet weak var resizePhoto: UIBarButtonItem!
    
    
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
        bottomText.textAlignment = .Center
        
        //Create initial text
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        //Hide share button until image is selected
        shareButton.enabled = false
        resizePhoto.enabled = false
        
        //Reset image
        imagePickerView.image = nil
        return
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Subscribe to notifications from keyboard object
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe to notifications from keyboard object when closing view controller
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        //Receive notifications when keyboard is shown and hidden
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
        
        //If editing is started in bottom textfield, frame shall be moved up to avoid textfield being covered by the keyboard, if not already moved up
        if bottomText.isFirstResponder() && view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        //Get geometric info regarding keyboard size
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        let keyboardHeight = keyboardSize.CGRectValue().height
        
        //If editing is stopped in bottom textfield, frame is moved back down as keyboard is removed, if frame not already lowered.
        if bottomText.isFirstResponder() && view.frame.origin.y != 0 {
            view.frame.origin.y += keyboardHeight
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        //Assign image from image picker to this class, scaling it to fit in the image view. Share and resize buttons are enabled and picker controller is dismissed.
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = image
            shareButton.enabled = true
            resizePhoto.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
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
        return
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Increases width of textfield as user types each character and recenters textfield. This ensures user can continue to see all text whilst typing
        if textField.frame.size.width < (view.frame.size.width - 20) {
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
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Present tool bar and nav bar again
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    
    func saveMeme(memedImage: UIImage) {
        //Create meme object
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!
            , memedImage: memedImage, contentSizing: imagePickerView.contentMode)
        
        //Add Meme to Memes array on the AppDelegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        return
    }
    
    
    func selectImage(source: UIImagePickerControllerSourceType){
        //Instantiate image picker controller, allow the current class to be its delegate, use the Camera as the source and present the view controller
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }


    @IBAction func takePhoto(sender: UIBarButtonItem) {
        selectImage(UIImagePickerControllerSourceType.Camera)
    }

    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        selectImage(UIImagePickerControllerSourceType.PhotoLibrary)
   }
    

    @IBAction func bottomText(sender: UITextField) {
        //Needed to secure correct functioning of BottomText notification
    }
  
    @IBAction func resizePhoto(sender: AnyObject) {
        //Button allows user to toggle between Scale Aspect Fit and Scale Aspect Fill content modes
        if (imagePickerView.contentMode == .ScaleAspectFit){
            imagePickerView.contentMode = .ScaleAspectFill
        }
        else {
            imagePickerView.contentMode = .ScaleAspectFit
        }
    }
    
    @IBAction func shareImage(sender: UIBarButtonItem) {
        //Generate the memed image and pass it to the activity controller
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //If user completes action in view controller save the Meme and dismiss the view controller
        activityController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        //Present the controller
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        //Reset screen to initial parameters
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

