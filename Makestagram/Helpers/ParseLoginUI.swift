//
//  ParseLoginUI.swift
//  Makestagram
//
//  Created by Rajesh on 8/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class MyLogInViewController : PFLogInViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
//        let logoView = UIImageView(image: UIImage(named:"logo.png"))
//        self.logInView?.logo = logoView
    }
    
}