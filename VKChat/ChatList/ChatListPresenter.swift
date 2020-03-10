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
    func viewDidAppear()
    func retryAuth()
    func loadMorePosts()
}

class ChatListPresenter: ChatListViewOutput {
    unowned var view: ChatListViewInput!
    
    var currentOffset = 0
    var canLoadMore = true
    var uploadedPosts = FeedTableDataModule(groups: [], posts: [])
    
    func viewWillAppear() {
        VKSDKManager.shared.authCompletionBlock = handleSucesfullAuth
        VKSDKManager.shared.authFailBlock = handleFailAuth(error:)
        VKSDKManager.shared.authNeedPresentController = view.presentAuthController(controller:)
    }
    
    func viewDidAppear() {
        checkAuth()
    }
    
    func retryAuth() {
        checkAuth()
    }
    
    func loadMorePosts() {
        getNewsfeed()
        canLoadMore = false
    }
}

private extension ChatListPresenter {
    func checkAuth() {
        VKSDKManager.shared.checkSessionStatus(completionBlock: handleSucesfullAuth, errorBlock: handleFailAuth(error:))
    }
    
    func getCurrentUserInfo() {
        VKSDKManager.shared.getCurrentUserInfo(completionBlock: view.updateUserInfoView(with:), errorBlock: view.showError(error:))
    }
    
    func getNewsfeed() {
        guard canLoadMore else {
            return
        }
        
        VKSDKManager.shared.getWall(withOffset: currentOffset, completionBlock: {(posts) in
            print(self.currentOffset)
            self.uploadedPosts.posts.append(contentsOf: posts.posts)
            self.view.updateView(withItems: self.uploadedPosts)
            self.canLoadMore = true
            self.currentOffset += 50
        }, errorBlock: self.view.showError(error:))
    }
    
    func handleSucesfullAuth() {
        self.getCurrentUserInfo()
        self.getNewsfeed()
    }
    
    func handleFailAuth(error: Error) {
        self.view.showError(error: error)
    }
}
