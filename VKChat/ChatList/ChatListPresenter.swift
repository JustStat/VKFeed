//
//  ChatListPresenter.swift
//  VKChat
//
//  Created by Kirill Varlamov on 19/02/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import Foundation

protocol ChatListViewOutput {
    var view: ChatListViewInput! {get set}
    func loadChatList()
}

class ChatListPresenter: ChatListViewOutput {
    unowned var view: ChatListViewInput!
    
    func loadChatList() {
        view.updateView(withItems: ["sadsd", "sadsd", "sadsd", "sadsd"])
    }
}
