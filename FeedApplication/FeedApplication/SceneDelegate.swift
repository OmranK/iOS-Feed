//
//  SceneDelegate.swift
//  FeedApplication
//
//  Created by Omran Khoja on 3/11/22.
//

import UIKit
import CoreData
import FeedCoreModule
import FeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")

    private lazy var httpClient: HTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        return URLSessionHTTPClient(session: session)
    }()
    
    private lazy var store: FeedStore & ImageStore = {
        try! CoreDataFeedStore(storeURL: localStoreURL)
    }()

    convenience init(httpClient: HTTPClient, store: FeedStore & ImageStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        configureWindow()
    }
      
    func configureWindow() {
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let client = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        let remoteImageLoader = RemoteImageLoader(client: client)
        
        
        let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalImageLoader(store: store)
        
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedControllerComposedWith(
        feedLoader: FeedLoaderWithFallbackComposite(
            primary: FeedLoaderCacheDecorator(
                decoratee: remoteFeedLoader,
                cache: localFeedLoader),
            fallback: localFeedLoader),
        imageLoader: ImageLoaderWithFallbackComposite(
            primary: localImageLoader,
            fallback: ImageLoaderCacheDecorator(
                decoratee: remoteImageLoader,
                cache: localImageLoader))))

    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient
    }
}
