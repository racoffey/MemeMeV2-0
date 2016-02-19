//
//  Meme.swift
//  MemeMev2.0
//
//  Created by Robert Coffey on 16/01/2016.
//  Copyright © 2016 Robert Coffey. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    // Object parameters, including content mode setting chosen by user
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
    var contentSizing: UIViewContentMode
}