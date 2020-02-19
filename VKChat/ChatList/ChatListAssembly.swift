//
//  ChatListAssembly.swift
//  VKChat
//
//  Created by Kirill Varlamov on 19/02/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import Foundation
import Swinject

class ChatListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ChatListViewInput.self) { resolver in
            let viewController = ChatListViewController()
            viewController.presenter = resolver.resolve(ChatListViewOutput.self)
            
            return viewController
        }
        
        container.register(ChatListViewOutput.self) { _ in ChatListPresenter() }.initCompleted { (resolver, output) in
            var presenter = output
            presenter.view = resolver.resolve(ChatListViewInput.self)!
        }
    }
    
    
}
