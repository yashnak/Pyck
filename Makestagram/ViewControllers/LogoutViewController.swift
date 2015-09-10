//
//  LogoutViewController.swift
//  Makestagram
//
//  Created by Rajesh on 8/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class LogoutViewController: UIViewController {
    var parseLoginHelper: ParseLoginHelper!
    var appDelegate: AppDelegate!

    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
//    @IBAction func logOutButtonPressed(sender: AnyObject) {
//        PFUser.logOut()
//        var currentUser = PFUser.currentUser()
//        //self.performSegueWithIdentifier(l, sender: self)
//////
//    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.loginSetup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    
//    func loginSetup() {
//        
//        if (PFUser.currentUser() == nil) {
//            
//            var loginViewController = PFLogInViewController()
//           // loginViewController.delegate = self
//            
//            var signUpViewController = PFSignUpViewController()
//           // signUpViewController.delegate = self
//            
//            loginViewController.signUpController = signUpViewController
            
            
//            
//            self.presentViewController(AppDelegate.l, animated: true, completion: nil)
//
//        }
//    
//
//        
//    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
