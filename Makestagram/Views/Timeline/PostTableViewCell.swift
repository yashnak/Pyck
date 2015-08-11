//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Benjamin Encz on 5/26/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

protocol CellButtonTappedDelegate {
    func cellButtonWasTapped(theCell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {

  @IBOutlet weak var postImageView: UIImageView!
  //@IBOutlet weak var likesIconImageView: UIImageView!
  //@IBOutlet weak var likesLabel: UILabel!
  //@IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var mainView: UIView!
  weak var timeline: TimelineViewController?
    var delegate: CellButtonTappedDelegate?
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var toPass: String!
    
  var likeBond: Bond<[PFUser]?>!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
  
  var post:Post? {
    didSet {
      // free memory of image stored with post that is no longer displayed
      if let oldValue = oldValue where oldValue != post {
        likeBond.unbindAll()
        postImageView.designatedBond.unbindAll()
        if (oldValue.image.bonds.count == 0) {
          oldValue.image.value = nil
        }
      }
      
      if let post = post {
        usernameLabel.text = post.user?.username
        captionLabel.text = toPass
        mainView.layer.cornerRadius = 10;
        mainView.layer.masksToBounds = true;
        captionLabel.text = post.caption
        // bind the image of the post to the 'postImage' view
        post.image ->> postImageView
        
        // bind the likeBond that we defined earlier, to update like label and button when likes change
        post.likes ->> likeBond
              }
    }
  }
  
  //MARK: Initialization
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
      if let likeList = likeList {
        //self.likesLabel.text = self.stringFromUserlist(likeList)
        //self.likeButton.selected = contains(likeList, PFUser.currentUser()!)
        //self.likesIconImageView.hidden = (likeList.count == 0)
      } else {
        // if there is no list of users that like this post, reset everything
        //self.likesLabel.text = ""
        //self.likeButton.selected = false
        //self.likesIconImageView.hidden = true
      }
    }
  }
  
  // MARK: Button Callbacks
  
    @IBAction func addButtonTapped(PostTableViewCell: AnyObject) {
        delegate!.cellButtonWasTapped(self)
    }
    
  @IBAction func moreButtonTapped(sender: AnyObject) {
    timeline?.showActionSheetForPost(post!)
  }
  
  // Technically this should live in the VC, decide whether or not we should keep it here for simplicity
  @IBAction func likeButtonTapped(sender: AnyObject) {
    post?.toggleLikePost(PFUser.currentUser()!)
  }
    
    //tossing views
    
  //MARK: Helper functions
  
  // Generates a comma seperated list of usernames from an array (e.g. "User1, User2")
  func stringFromUserlist(userList: [PFUser]) -> String {
    let usernameList = userList.map { user in user.username! }
    let commaSeperatedUserList = ", ".join(usernameList)
    
    return commaSeperatedUserList
  }
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    
    
     
    
  
  
}