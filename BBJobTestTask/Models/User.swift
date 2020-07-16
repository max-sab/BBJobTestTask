//
//  User.swift
//  BBJobTestTask
//
//  Created by Maksym Sabadyshyn on 7/16/20.
//  Copyright © 2020 Maksym Sabadyshyn. All rights reserved.
//

import Foundation

struct Person: Decodable {
    let firstName: String
    let lastName: String
    let avatar: String
    let id: Int
    let email: String
}
