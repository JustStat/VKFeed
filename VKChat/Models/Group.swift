//
//  Groups.swift
//  VKChat
//
//  Created by Kirill Varlamov on 10/03/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import Foundation

struct Group {
    let id: Int
    let name: String
    let photo: String
    
    init?(withDictionary dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int else {
            return nil
        }
        
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        
        guard let photo = dictionary["photo_50"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.photo = photo
    }
}
