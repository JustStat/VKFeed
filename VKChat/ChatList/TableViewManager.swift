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
    var items = [String]()
    
    init(tableView: inout UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ChatListTableViewDataSource.chatListCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewDataSource.chatListCellIdentifier) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}
