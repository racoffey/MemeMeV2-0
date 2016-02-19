//
//  MemeDetailViewController.swift
//  MemeMev1.0
//
//  Created by Robert Coffey on 16/01/2016.
//  Copyright © 2016 Robert Coffey. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editMemeButton: UIBarButtonItem!
    
    var meme: Meme!
    
    // Show memed image in detailed view and hide tab bar
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = meme.memedImage
        self.tabBarController?.tabBar.hidden = true
        self.editMemeButton.enabled = true
    }
    
    // Show tab bar again when closing view
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    // Instantiate edit meme controller, pass selected meme, and set wanted parameters settings
    @IBAction func editMeme(sender: AnyObject) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        presentViewController(resultVC, animated: true, completion: nil)
        resultVC.topText.text = self.meme.topText
        resultVC.bottomText.text = self.meme.bottomText
        resultVC.imagePickerView.image = self.meme.image
        resultVC.imagePickerView.contentMode = self.meme.contentSizing
        resultVC.shareButton.enabled = true
        resultVC.resizePhoto.enabled = true
    }
    
}
