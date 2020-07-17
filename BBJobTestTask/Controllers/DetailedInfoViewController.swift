//
//  DetailedInfoViewController.swift
//  BBJobTestTask
//
//  Created by Maksym Sabadyshyn on 7/17/20.
//  Copyright © 2020 Maksym Sabadyshyn. All rights reserved.
//

import UIKit

class DetailedInfoViewController: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var user: User?
    var userImage: UIImage = #imageLiteral(resourceName: "defaultAvatar")

    override func viewDidLoad() {
        if let user = user {
            userAvatar.image = userImage
            nameLabel.text = user.firstName + " " + user.lastName
            emailLabel.text = user.email
        }
    }

}
