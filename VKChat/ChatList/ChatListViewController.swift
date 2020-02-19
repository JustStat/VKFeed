//
//  ChatListViewController.swift
//  VKChat
//
//  Created by Kirill Varlamov on 19/02/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import UIKit
import PureLayout

protocol ChatListViewInput: AnyObject {
    var presenter: ChatListViewOutput! {get set}
    func updateView(withItems items: [String])
}

class ChatListViewController: UIViewController, ChatListViewInput {
    var presenter: ChatListViewOutput!
    
    private var chatsTable = UITableView()
    private var dataSource: ChatListTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chatsTable)
        configureConstraints()
        
        dataSource = ChatListTableViewDataSource(tableView: &chatsTable)
        chatsTable.dataSource = dataSource
        
        presenter.loadChatList()
    }
    
    func configureConstraints() {
        chatsTable.autoPinEdgesToSuperviewEdges()
    }
    
    func updateView(withItems items: [String]) {
        dataSource.items = items
        chatsTable.reloadData()
    }
}

extension ChatListViewController: UITableViewDelegate {
    
}
