

import UIKit
import Parse
import ConvenienceKit

class TimelineViewController: UIViewController, TimelineComponentTarget {
  @IBOutlet weak var tableView: UITableView!
  
  var photoTakingHelper: PhotoTakingHelper?
  
  // Timeline Component Protocol
  let defaultRange = 0...4
  let additionalRangeSize = 5
  var timelineComponent: TimelineComponent<Post, TimelineViewController>!
    
    

  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    timelineComponent = TimelineComponent(target: self)
    self.tabBarController?.delegate = self
    
//    tableView.rowHeight = UITableViewAutomaticDimension
//    tableView.estimatedRowHeight = 500
    
   tableView.backgroundColor = UIColor.blackColor()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  
    timelineComponent.loadInitialIfRequired()
    self.timelineComponent.refresh(self)
  }
  
  // MARK: TimelineComponentTarget implementation
  
  func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
    ParseHelper.timelineRequestforCurrentUser(range) {
      (result: [AnyObject]?, error: NSError?) -> Void in
        if let error = error {
          ErrorHandling.defaultErrorHandler(error)
        }
      
        let posts = result as? [Post] ?? []
        completionBlock(posts)
    }
  }
  
  // MARK: View callbacks
  
  func takePhoto() {
    // instantiate photo taking class, provide callback for when photo is selected
    photoTakingHelper =
      PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
        let post = Post()
        post.image.value = image!
        post.uploadPost()
        //This code doesn't actually get used...
        //Don't modify it thinking it'll change things
    }
  }
    
  // MARK: UIActionSheets

  func showActionSheetForPost(post: Post) {
      if (post.user == PFUser.currentUser()) {
          showDeleteActionSheetForPost(post)
      } else {
          showFlagActionSheetForPost(post)
      }
  }
  
  func showDeleteActionSheetForPost(post: Post) {
    let alertController = UIAlertController(title: nil, message: "Do you want to delete this post?", preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
      post.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
        if (success) {
          self.timelineComponent.removeObject(post)
        } else {
          // restore old state
          self.timelineComponent.refresh(self)
        }
      })
    }
    alertController.addAction(destroyAction)
    
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
    //
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  func showFlagActionSheetForPost(post: Post) {
    let alertController = UIAlertController(title: nil, message: "Do you want to flag this post?", preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let destroyAction = UIAlertAction(title: "Flag", style: .Destructive) { (action) in
      post.flagPost(PFUser.currentUser()!)
    }
    
    alertController.addAction(destroyAction)
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            
            var svc = segue.destinationViewController as! PhotoTakingViewController;
            
            
            
        }
    }

   
    


  
}



// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
  
  func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
    if (viewController is PhotoViewController) {
      takePhoto()
      return false
    } else {
      return true
    }
  }
  
}

// MARK: TableViewDataSource

extension TimelineViewController: UITableViewDataSource, CellButtonTappedDelegate {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.timelineComponent.content.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell

    cell.delegate = self
    let post = timelineComponent.content[indexPath.section]
    post.downloadImage()
    post.fetchLikes()
    cell.post = post
    cell.timeline = self
    
    return cell
  }
  
    func cellButtonWasTapped(theCell: PostTableViewCell) {
        let photoTakingVC: PhotoTakingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("photoTakingViewController") as! PhotoTakingViewController
        photoTakingVC.thePost = theCell.post
        self.presentViewController(photoTakingVC, animated: true, completion: nil)
    }
}

// MARK: TableViewDelegate

extension TimelineViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    timelineComponent.targetWillDisplayEntry(indexPath.section)
    TipInCellAnimator.animate(cell)
    
      }
  
// func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            timelineComponent.content.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//        }
//    }
//  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeader") as! PostSectionHeaderView
//    
//    let post = self.timelineComponent.content[section]
//    headerCell.post = post
//    
//    return headerCell
//  }
  
}

// MARK: Style

extension TimelineViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}