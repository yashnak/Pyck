//
//  PhotoTakingViewController.swift
//  Makestagram
//
//  Created by Rajesh on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class PhotoTakingViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var captionTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    
    let picker = UIImagePickerController()
    var photoTakingHelper : PhotoTakingHelper?
//    var thePhotoToEdit: UIImage?
    var thePost: Post?

    //drawing
    @IBOutlet weak var finalView: UIView!
    
    @IBOutlet weak var drawView: UIImageView!
    @IBAction func eraserPressed(sender: UIButton) {
    
    }
    @IBAction func pencilPressed(sender: UIButton) {
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        // 2
        (red, green, blue) = colors[index]
        
        // 3
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if((self.presentingViewController) != nil){
            self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
            println("cancel")
        }
    }

    var lastPoint = CGPoint.zeroPoint
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    //camera
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = sender
    
    }
    
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }

    @IBAction func saveImage() {
        
        let post = Post()
        post.image.value = pb_takeSnapshot(finalView)
        post.caption = captionTextField.text
        post.uploadPost()
        
        if let helper = photoTakingHelper {
            //            helper.successCallback(myImageView.image)
            //Uploads the image (by calling success
            helper.viewController.dismissViewControllerAnimated(true, completion: nil)
            //Dismisses the view controllers
        } else {
            self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
            //Dismisses the view controller
            
            //Upload the image
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.myImageView.image = self.thePost!.image.value
        finalView.backgroundColor = UIColor.blackColor()
        drawView.backgroundColor = UIColor.clearColor()
        myImageView.backgroundColor = UIColor.blackColor()
        //captionTextField.returnKeyType = .Done
        self.captionTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    

//        self.drawView.image = self.thePost!.image.value
//        self.drawView.image = pb_takeSnapshot(drawView)
        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 350
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 350
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .ScaleAspectFit //3
        myImageView.image = chosenImage //4
        
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   /////////////********drawing***********/////////////////
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
    ]
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        swiped = false
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(self.drawView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(drawView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        drawView.image?.drawInRect(CGRect(x: 0, y: 0, width: drawView.frame.size.width, height: drawView.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        drawView.image = UIGraphicsGetImageFromCurrentImageContext()
//        myImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func pb_takeSnapshot(snapshotView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size, false, UIScreen.mainScreen().scale)
        
        snapshotView.drawViewHierarchyInRect(snapshotView.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 6
        swiped = true
        if let touch = touches.first as? UITouch {
            let currentPoint = touch.locationInView(drawView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        
        
               
//        // Merge tempImageView into myImageView
//        UIGraphicsBeginImageContext(myImageView.frame.size)
//        myImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
//       tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
//        //myImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
    }
    
    //filters
    
    

    
}
