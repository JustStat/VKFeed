//
//  PostTableViewCell.swift
//  VKChat
//
//  Created by Kirill Varlamov on 10/03/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import UIKit

final class PostTableViewCell: UITableViewCell {
    private let offset: CGFloat = 20
    
    private let postImageView = UIImageView()
    private let label = UILabel()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    var post: Post {
        didSet {
            self.postImageView.image = post.attachements?.photos?.first?.image
            self.label.text = post.text
            layoutSubviews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.post = Post(withDictionary: [:])
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(postImageView)
        contentView.addSubview(label)
        contentView.addSubview(separator)
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        postImageView.image = nil
        post = Post(withDictionary: [:])
        label.text = ""
        postImageView.frame = .zero
        label.frame = .zero
    }
    
    override func layoutSubviews() {
        if let originalWidth = post.attachements?.photos?.first?.width,
            let originalHeight = post.attachements?.photos?.first?.height {
            let aspect = contentView.bounds.width / CGFloat(originalWidth)
            postImageView.frame = CGRect(x: offset, y: offset, width: contentView.bounds.width - offset * 2, height: CGFloat(originalHeight) * aspect)
        }
        
        if let _ = post.text {
            let height = post.text?.height(withConstrainedWidth: contentView.bounds.width - offset * 2, font: UIFont.systemFont(ofSize: 14))
            label.frame = CGRect(x: offset, y: postImageView.frame.maxY + offset, width: contentView.bounds.width - offset * 2, height: height ?? 0)
        }
        
        separator.frame = CGRect(x: 0, y: label.frame.maxY + offset, width: contentView.bounds.width, height: 30)
    }
}
