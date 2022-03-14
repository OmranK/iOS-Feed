//
//  SceneDelegate.swift
//  FeedApplication
//
//  Created by Omran Khoja on 3/11/22.
//

import UIKit
import FeedCoreModule
import FeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        let remoteImageLoader = RemoteImageLoader(client: client)
        
        window?.rootViewController =
        FeedUIComposer.feedControllerComposedWith(
            feedLoader: remoteFeedLoader,
            imageLoader: remoteImageLoader)
    }
}

