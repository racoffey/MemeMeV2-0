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
    @IBOutlet weak var label: UILabel!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.label.text = self.meme.topText
        self.label.text = self.meme.bottomText
        
        self.tabBarController?.tabBar.hidden = true
        
        self.imageView!.image = meme.image
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}
