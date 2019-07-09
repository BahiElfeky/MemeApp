//
//  MemedImage.swift
//  MemeMe 1.0
//
//  Created by Bahi El Feky on 3/9/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import Foundation
import UIKit
class MemedImage {
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
    init(topText:String, bottomText:String, originalImage:UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
