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
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()

    convenience init(httpClient: HTTPClient, store: FeedStore & ImageStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient
    }
    
    // MARK: - Composition with Combine Framework + universal abstractions
    
    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedControllerComposedWith(
        feedLoader: makeRemoteFeedLoaderWithLocalFallback,
        imageLoader: makeLocalImageLoaderWithRemoteFallback))
        
        window?.makeKeyAndVisible()
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher {
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let client = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        return remoteFeedLoader
            .loadPublisher()
            .cacheing(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> ImageLoader.Publisher {
        let client = makeRemoteClient()
        let remoteImageLoader = RemoteImageLoader(client: client)
        let localImageLoader = LocalImageLoader(store: store)
        return localImageLoader
            .loadImagePublisher(with: url)
            .fallback(to: {
                remoteImageLoader
                    .loadImagePublisher(with: url)
                    .cacheing(to: localImageLoader, using: url)
            })
    }
    
    
    // MARK: - Composition with Design Patterns
    
//    func configureWindow() {
//        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
//        let client = makeRemoteClient()
//        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
//        let remoteImageLoader = RemoteImageLoader(client: client)
//        let localImageLoader = LocalImageLoader(store: store)
        
//        window?.rootViewController = UINavigationController(
//            rootViewController: FeedUIComposer.feedControllerComposedWith(
//        feedLoader: FeedLoaderWithFallbackComposite(
//            primary: FeedLoaderCacheDecorator(
//                decoratee: remoteFeedLoader,
//                cache: localFeedLoader),
//            fallback: localFeedLoader),
//        imageLoader: ImageLoaderWithFallbackComposite(
//            primary: localImageLoader,
//            fallback: ImageLoaderCacheDecorator(
//                decoratee: remoteImageLoader,
//                cache: localImageLoader))))
//    }
    
}
