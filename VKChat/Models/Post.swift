//
//  Post.swift
//  VKChat
//
//  Created by Kirill Varlamov on 06/03/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import UIKit

struct Attachments {
    let photos: [PhotoAttachment]?
    
    var description: String {
        get {
            var str = "attachents: ["
            
            guard let photos = photos else {
                return "attachents: []"
            }
            
            for photo in photos {
                str += photo.description
            }
            
            return str
        }
    }
}

struct Post {
    let text: String?
    let attachements: Attachments?
    let owner: User
    
    var description: String {
        get {
            "text: \(text ?? "nil"), \(attachements?.description ?? "arrachments: nil") \n"
        }
    }
    
    init(withDictionary dictionary: [String: Any]) {
        if let text = dictionary["text"] as? String {
            self.text = text
        } else {
            self.text = nil
        }
        
        func parseAttachments() -> Attachments? {
            if
                let attachemntsJSON = dictionary["attachments"] as? [[String: Any]],
                attachemntsJSON.count > 0
            {
                var photos = [PhotoAttachment]()
                for attachemnt in attachemntsJSON {
                    if let photo = PhotoAttachment(withDictionary: attachemnt) {
                        photos.append(photo)
                    }
                }
                
                if photos.count > 0 {
                    return Attachments(photos: photos)
                }
            }
            
            return nil
        }
        
        self.attachements = parseAttachments()
        self.owner = User(id: 0, photo: "", firstName: "", lastName: "", status: "")
    }
}
