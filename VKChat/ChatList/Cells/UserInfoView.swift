//
//  UserInfoVIew.swift
//  VKChat
//
//  Created by Kirill Varlamov on 05/03/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import UIKit
import PureLayout

final class UserInfoViewCell: UITableViewCell {
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let userStatusLabel = UILabel()
    
    var user: User = User(id: 0, photo: "", firstName: "", lastName: "", status: "") {
        didSet {
            setup(with: user)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userStatusLabel)
        
        userStatusLabel.numberOfLines = 0
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        userImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        userImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        NSLayoutConstraint.autoSetPriority(UILayoutPriority(999)) {
            userImageView.autoSetDimensions(to: CGSize(width: 50, height: 50))
        }
        userImageView.layer.cornerRadius = 50 / 2
        userImageView.clipsToBounds = true
        
        userNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        userNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        userNameLabel.autoPinEdge(.left, to: .right, of: userImageView, withOffset: 20)
        userNameLabel.autoSetDimension(.height, toSize: 20)
        
        userStatusLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        userStatusLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        userStatusLabel.autoPinEdge(.left, to: .right, of: userImageView, withOffset: 20)
        userStatusLabel.autoPinEdge(.top, to: .bottom, of: userNameLabel, withOffset: 20)
        
        super.updateConstraints()
    }
    
    func setup(with user: User) {
        if let url = URL(string: user.photo ?? "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.userImageView.image = UIImage(data: data)
                    }
                } else if error != nil {
                    print("Error! While uploading photo")
                }
            }.resume()
        }
        
        userNameLabel.text = user.fullName
        userStatusLabel.text = user.status
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
