//
//  GIFDetailsCoordinator.swift
//  Dispo Take Home
//
//  Created by Julian Builes on 1/18/22.
//

import Foundation
import UIKit

class GIFDetailsCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?
    private var gifStub: GIFStub
    
    // MARK: - Initiatizer
    init(navigationController: UINavigationController, gifStub: GIFStub) { self.navigationController = navigationController
        self.gifStub = gifStub
    }
    
    func start() {
        let gifDetailsVC = GIFDetailsViewController(stub: gifStub)
        let viewModel = GIFDetailsViewModel(service: GIFService<GIFResponse>())
        gifDetailsVC.viewModel = viewModel
        viewModel.coordinator = self
        navigationController.pushViewController(gifDetailsVC, animated: true)
    }
    
    func willDismissView() {
        parentCoordinator?.childDidFinish(child: self)
    }
}
