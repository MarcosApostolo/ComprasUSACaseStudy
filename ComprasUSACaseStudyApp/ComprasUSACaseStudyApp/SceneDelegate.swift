//
//  SceneDelegate.swift
//  ComprasUSACaseStudyApp
//
//  Created by Marcos Amaral on 30/04/24.
//

import UIKit
import Combine
import CoreData
import ComprasUSAiOS
import ComprasUSACaseStudy

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // This force try will be removed once the App composition is complete
        let store = try! CoreDataStore(storeURL: NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite"))
        
        let loader = PurchaseFeatureUseCase(store: store)
        
        let vc = PurchasesListUIComposer.composePurchasesList(loader: {
            loader
                .loadPurchasesPublisher()
                .eraseToAnyPublisher()
        }, onPurchaseRegister: {})
        
        let window = UIWindow(windowScene: scene)
        
        window.makeKeyAndVisible()
        
        window.rootViewController = vc
        
        self.window = window
    }
}

