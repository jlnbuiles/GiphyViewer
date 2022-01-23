//
//  GIFListCoordinator.swift
//  Dispo Take Home
//
//  Created by Julian Builes on 1/18/22.
//

import Foundation
import UIKit
    
final class GIFListCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?
    
    // MARK: - Initiatizer
    init(navigationController: UINavigationController) { self.navigationController = navigationController
    }
    
    // MARK: - Navigation
    func start() {
        let gifListVC = GIFListViewController()
        let viewModel = GIFListViewModel(service: GIFService())
        gifListVC.viewModel = viewModel
        viewModel.coordinator = self
        navigationController.setViewControllers([gifListVC], animated: false)
    }
    
    func displayDetailsFor(stub: GIFStub) {
        let gifDetailsCoord = GIFDetailsCoordinator(navigationController: navigationController, gifStub: stub)
        gifDetailsCoord.parentCoordinator = parentCoordinator
        childCoordinators.append(gifDetailsCoord)
        gifDetailsCoord.start()
    }
    
    func didFinishDisplayingList() {
        print("do something here to signify the end of this flow.")
    }
    
    func childDidFinish(thecoord: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { element in
            element === thecoord}) { childCoordinators.remove(at: index) }
    }
}
