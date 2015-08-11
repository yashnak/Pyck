//
//  FriedListTableViewCell.swift
//  Makestagram
//
//  Created by Rajesh on 8/8/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

//protocol FriedListTableViewCellDelegate: class {
//    func cell(cell: FriedListTableViewCell, didSelectFollowUser user: PFUser)
//    func cell(cell: FriedListTableViewCell, didSelectUnfollowUser user: PFUser)
//}

class FriedListTableViewCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
   
    
    var user: PFUser? {
        didSet {
        usernameLabel.text = user?.username
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
