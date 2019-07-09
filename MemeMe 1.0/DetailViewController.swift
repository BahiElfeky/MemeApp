//
//  DetailViewController.swift
//  MemeMe 1.0
//
//  Created by Bahi El Feky on 4/6/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme : MemedImage!
    @IBOutlet weak var DetailImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DetailImage.image = meme.memedImage
    }
    
}
