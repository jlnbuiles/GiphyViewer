//
//  AppCoordinator.swift
//
//  Created by Julian Builes on 1/14/22.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
    func childDidFinish(child: Coordinator)
}

extension Coordinator {
    // empty implementation to make it optional.
    func childDidFinish(child: Coordinator) { }
}

final class AppCoordinator: Coordinator {

    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController: UINavigationController
    private let window: UIWindow

    // MARK: - Initializer
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    // MARK: - Navigation
    func start() {
        let gifListCoordinator = GIFListCoordinator(navigationController: navigationController)
        childCoordinators.append(gifListCoordinator)
        gifListCoordinator.start()
        gifListCoordinator.parentCoordinator = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if child === coordinator { childCoordinators.remove(at: index) }
        }
    }
}
