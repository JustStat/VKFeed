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
    func viewWillAppear()
    func retryAuth()
}

class ChatListPresenter: ChatListViewOutput {
    unowned var view: ChatListViewInput!
    
    func viewWillAppear() {
        VKSDKManager.shared.authCompletionBlock = handleSucesfullAuth
        VKSDKManager.shared.authFailBlock = handleFailAuth(error:)
        checkAuth()
    }
    
    func retryAuth() {
        checkAuth()
    }
}

private extension ChatListPresenter {
    func checkAuth() {
        VKSDKManager.shared.checkSessionStatus(completionBlock: handleSucesfullAuth, errorBlock: handleFailAuth(error:))
    }
    
    func getCurrentUserInfo() {
        VKSDKManager.shared.getCurrentUserInfo(completionBlock: view.updateUserInfoView(with:), errorBlock: view.showError(error:))
    }
    
    func getNewsfeed(withOffset offset: Int) {
        VKSDKManager.shared.getWall(withOffset: offset, completionBlock: view.updateView(withItems:), errorBlock: self.view.showError(error:))
    }
    
    func handleSucesfullAuth() {
        self.getCurrentUserInfo()
        self.getNewsfeed(withOffset: 0)
    }
    
    func handleFailAuth(error: Error) {
        self.view.showError(error: error)
    }
}
