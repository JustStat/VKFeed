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
    func updateView(withItems items: FeedTableDataModule)
    func updateUserInfoView(with user: User)
    func showError(error: Error)
    func presentAuthController(controller: UIViewController)
}

class ChatListViewController: UIViewController, ChatListViewInput {
    var presenter: ChatListViewOutput!
    
    private var chatsTable = UITableView(frame: .zero)
    private var dataSource: ChatListTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(chatsTable)
        configureConstraints()
        
        dataSource = ChatListTableViewDataSource(tableView: chatsTable)
        dataSource.tableDidScrollToBottom = { [weak self] in
            self?.presenter.loadMorePosts()
        }
        
        chatsTable.dataSource = dataSource
        chatsTable.delegate = dataSource
        chatsTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
    
    func configureConstraints() {
        chatsTable.autoPinEdgesToSuperviewSafeArea()
    }
    
    func updateView(withItems items: FeedTableDataModule) {
        dataSource.items = items
        chatsTable.reloadData()
    }
    
    func updateUserInfoView(with user: User) {
        dataSource.userInfo = user
        chatsTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func showError(error: Error) {
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Перезагрузить", style: .default) { (action) in
            self.presenter.retryAuth()
        }
        
        alertController.addAction(restartAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentAuthController(controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
}
