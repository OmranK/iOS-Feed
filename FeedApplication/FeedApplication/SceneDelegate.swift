//
//  SceneDelegate.swift
//  FeedApplication
//
//  Created by Omran Khoja on 3/11/22.
//

import UIKit
import FeedCoreModule
import FeedPresentationModule
import FeediOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        let remoteImageLoader = RemoteImageLoader(client: client)
        
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalImageLoader(store: localStore)
        
        let feedViewController = FeedUIComposer.feedControllerComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(
                primary: remoteFeedLoader,
                fallback: localFeedLoader),
            imageLoader: ImageLoaderWithFallbackComposite(
                primary: localImageLoader,
                fallback: remoteImageLoader))
        
        window?.rootViewController = feedViewController
        
    }
}

