//
//  GIFDetailsViewModel.swift
//  Dispo Take Home
//
//  Created by Julian Builes on 1/18/22.
//

import Foundation
import RxSwift
import ProgressHUD

class GIFDetailsViewModel {

    // MARK: - Properties
    private var gifService: GIFService<GIFResponse>
    var publisher = PublishSubject<GIFResponse>()
    private var bag = DisposeBag()
    var coordinator: GIFDetailsCoordinator?
 
    // MARK: - Initializers
    init(service: GIFService<GIFResponse>) {
        self.gifService = service
    }
    
    // MARK: - Request bindings
    func fetchGIF(by id: String) {
        ProgressHUD.show("loading...")
        gifService.GETGIF(by: id).subscribe { [weak self] gif in
            self?.publisher.onNext(gif)
        } onError: { error in
            self.publisher.onError(error)
            ProgressHUD.dismiss()
        } onCompleted: {
            self.publisher.onCompleted()
            ProgressHUD.dismiss()
        }.disposed(by: bag)
    }
}
