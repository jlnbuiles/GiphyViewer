//
//  GIFListViewMOdel.swift
//  Dispo Take Home
//
//  Created by Julian Builes on 1/18/22.
//

import Foundation
import RxSwift
import ProgressHUD

class GIFListViewModel {
    
    // MARK: - Properties
    private var gifService: GIFService<GIFListResponse>
    var publisher = PublishSubject<[GIF]>()
    private var bag = DisposeBag()
    var coordinator: GIFListCoordinator?
    
    // MARK: - Initializers
    init(service: GIFService<GIFListResponse>) {
        self.gifService = service
    }
    
    // MARK: - Request bindings
    func fetchTrendingGIFList() {
        ProgressHUD.show("loading...")
        gifService.GETTrendingGIFs().subscribe { [weak self] gifsData in
            self?.publisher.onNext(gifsData.data)
        } onError: { error in
            self.publisher.onError(error)
            ProgressHUD.dismiss()
        } onCompleted: { 
            self.publisher.onCompleted()
            ProgressHUD.dismiss()
        }.disposed(by: bag)
    }
    
    func fetchSearchSearch(with searchTerm: String) {
        ProgressHUD.show("loading...")
        gifService.GETGIFs(by: searchTerm).subscribe { [weak self] gifsData in
            self?.publisher.onNext(gifsData.data)
        } onError: { error in
            self.publisher.onError(error)
            ProgressHUD.dismiss()
        } onCompleted: {
            self.publisher.onCompleted()
            ProgressHUD.dismiss()
        }.disposed(by: bag)
    }
    
    // MARK: - Actions
    func displayDetails(for gif: GIF) {
        coordinator?.displayDetailsFor(stub: GIFStub(gif))
    }
}
