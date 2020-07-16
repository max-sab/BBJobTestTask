//
//  UserCell.swift
//  BBJobTestTask
//
//  Created by Maksym Sabadyshyn on 7/16/20.
//  Copyright © 2020 Maksym Sabadyshyn. All rights reserved.
//

import UIKit
import Foundation

class PersonCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func setPerson(_ person: Person) {

        nameLabel.text = person.lastName + " " + person.firstName
        ImageProcessor.getImage(withUrl: person.avatarURL) { avatar in
            self.avatarImageView.image = avatar
            self.avatarImageView.setRounded()
        }
    }
}

extension UIImageView {
    
    //rounding input image
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
