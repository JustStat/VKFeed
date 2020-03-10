//
//  TableViewManager.swift
//  VKChat
//
//  Created by Kirill Varlamov on 19/02/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import UIKit

class ChatListTableViewDataSource: NSObject, UITableViewDataSource {
    private static let chatListCellIdentifier = "ChatListCell"
    private static let userInfoCellIdentifier = "UserInfoCell"
    
    var tableDidScrollToBottom: (() -> ())?
    
    var items = FeedTableDataModule(groups: [], posts: [])
    var userInfo = User(id: 0, photo: "", firstName: "", lastName: "", status: "")
    
    init(tableView: UITableView) {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: ChatListTableViewDataSource.chatListCellIdentifier)
        tableView.register(UserInfoViewCell.self, forCellReuseIdentifier: ChatListTableViewDataSource.userInfoCellIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section > 0 ? items.posts.count : 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewDataSource.userInfoCellIdentifier) as! UserInfoViewCell
            cell.user = userInfo
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewDataSource.chatListCellIdentifier) as! PostTableViewCell
            cell.contentView.clipsToBounds = true
            cell.post = items.posts[indexPath.row]
            
            return cell
        }
    }
}

extension ChatListTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return calculateHeightForRow(at: indexPath, width: tableView.bounds.width)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + 20 >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            tableDidScrollToBottom?()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 500 }
}

private extension ChatListTableViewDataSource {
    func calculateHeightForRow(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
           let post = items.posts[indexPath.row]
           
           var imageHeight: CGFloat = 0
           if
               let originalWidth = post.attachements?.photos?.first?.width,
               let originalHeight = post.attachements?.photos?.first?.height
           {
               let aspect = width / CGFloat(originalWidth)
               imageHeight = CGFloat(originalHeight) * aspect + 20
           }
                  
           
           var textHeight: CGFloat = 0
           if let postText = post.text, postText != "" {
               textHeight = postText.height(withConstrainedWidth: width - 40, font: UIFont.systemFont(ofSize: 14)) + 20
           }
           
           return imageHeight + textHeight + (imageHeight + textHeight == 0 ? 0 : 50)
    }
}
