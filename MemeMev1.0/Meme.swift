//
//  Meme.swift
//  MemeMev1.0
//
//  Created by Robert Coffey on 13/12/2015.
//  Copyright © 2015 Robert Coffey. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
    
    
    init (topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
        
    }
    

}
