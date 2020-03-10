//
//  Photo.swift
//  VKChat
//
//  Created by Kirill Varlamov on 10/03/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import UIKit

class PhotoAttachment {
    let url: String
    var image: UIImage?
    let height: Int
    let width: Int
    
    var description: String {
        get {
            return "url: \(url),\n width: \(width),\n height: \(height)"
        }
    }
    
    
    init?(withDictionary dictionary: [String: Any]) {
        guard dictionary["type"] as? String == "photo" else {
            return nil
        }
        
        guard let photoInfo = dictionary["photo"] as? [String: Any] else {
            return nil
        }
        
        guard let photoUrl = photoInfo["photo_604"] as? String else {
            return nil
        }
        
        self.url = photoUrl
        self.height = photoInfo["height"] as! Int
        self.width = photoInfo["width"] as! Int
        
        uploadPhoto()
    }
    
    private func uploadPhoto() {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    self.image = UIImage(data: data)
                } else if error != nil {
                    print("Error! While uploading photo")
                }
            }.resume()
        }
    }
}
