//
//  VKSDKManager.swift
//  VKChat
//
//  Created by Kirill Varlamov on 19/02/2020.
//  Copyright © 2020 Kirill Varlamov. All rights reserved.
//

import Foundation
import VK_ios_sdk

private let appId = "7330874"
private let scope = ["status", "wall", "friends"]
private let userFields = ["first_name", "last_name", "status", "photo_50"]

final class VKSDKManager: NSObject {
    static let shared = VKSDKManager()
    
    private var authController: UIViewController?
    
    var authCompletionBlock: (() -> ())?
    var authFailBlock: ((Error) -> ())?
    
    override init() {
        super.init()
        VKSdk.initialize(withAppId: appId)?.register(self)
        VKSdk.instance()?.uiDelegate = self
    }
    
    func checkSessionStatus(completionBlock: @escaping () -> (), errorBlock: @escaping (Error) -> ()) {
        VKSdk.wakeUpSession(scope) { (state, error) in
           if state == VKAuthorizationState.authorized {
                completionBlock()
           } else if let error = error {
                errorBlock(error)
           } else {
               VKSdk.authorize(scope)
           }
        }
    }
    
    func getCurrentUserInfo(completionBlock: @escaping (User) -> (), errorBlock: @escaping (Error) -> ()) {
        VKApi.users()?.get([VK_API_FIELDS: userFields])?.execute(resultBlock: { (response) in
            if
                let usersArray = response?.parsedModel as? VKUsersArray,
                let apiUser = usersArray.firstObject()
            {
                let user = User(id: apiUser.id.uintValue, photo: apiUser.photo_50, firstName: apiUser.first_name, lastName: apiUser.last_name, status: apiUser.status)
                completionBlock(user)
            }
        }, errorBlock: { (error) in
            errorBlock(error!)
        })
    }
    
    func getWall(withOffset: Int, completionBlock: @escaping (FeedTableDataModule) -> (), errorBlock: @escaping (Error) -> ()) {
        VKApi.request(withMethod: "newsfeed.get", andParameters: [:])?.execute(resultBlock: { (response) in
            if let dict = response?.json as? Dictionary<String, Any> {
                UserDefaults.standard.value(forKey: "Data")
                let groups = self.prepareGroups(json: dict)
                let posts = self.preparePosts(json: dict)

                let model = FeedTableDataModule(groups: groups, posts: posts)
                completionBlock(model)
            }
            
        }, errorBlock: { (error) in
            errorBlock(error!)
        })
    }
    
    func logOutUser() {
        VKSdk.forceLogout()
    }
    
    func presentAuthControllerIfNeeded(with controller: UIViewController) {
        if let authController = authController {
            controller.present(authController, animated: true, completion: nil)
            self.authController = nil
        }
    }
}

private extension VKSDKManager {
    func prepareGroups(json: [String: Any]) -> [Group] {
        guard let groupsJSON = json["groups"] else {
            return []
        }
        
        var groups = [Group]()
        for groupJSON in groupsJSON as! [[String: Any]] {
            if let group = Group(withDictionary: groupJSON) {
                groups.append(group)
            }
        }
        
        return groups
    }
    
    func preparePosts(json: [String: Any]) -> [Post] {
        guard let postsJSON = json["items"] else {
            return []
        }
        var posts = [Post]()
        for postJSON in postsJSON as! [[String: Any]] {
            posts.append(Post(withDictionary: postJSON))
        }
        
        return posts
    }
}

extension VKSDKManager: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            authCompletionBlock?()
        } else {
            authFailBlock?(result.error)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        //
    }
}

extension VKSDKManager: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        authController = controller
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        //
    }
    
    
}
