//
//  User.swift
//  VKChat
//
//  Created by Kirill Varlamov on 27/02/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import Foundation

struct User {
    let id: UInt
    let photo: String?
    let firstName: String
    let lastName: String
    let status: String?
    
    var fullName: String {
        get {
            firstName + " " + lastName
        }
    }
}
