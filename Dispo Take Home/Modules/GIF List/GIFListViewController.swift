import UIKit
import RxSwift
import RxCocoa

class GIFListViewController: UIViewController {

    // MARK: - Properties
    private var disposeBag = DisposeBag()
    var viewModel: GIFListViewModel!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search gifs in a 'giphy'..."
        searchBar.delegate = self
        return searchBar
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(GIFCell.self, forCellWithReuseIdentifier: GIFCell.identifier())
        return collectionView
    }()
    
    private var layout: UICollectionViewFlowLayout {
        let theLayout = UICollectionViewFlowLayout()
        theLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        theLayout.minimumLineSpacing = 0
        theLayout.minimumInteritemSpacing = 0
        theLayout.itemSize =  CGSize(width: UIScreen.main.bounds.width, height: GIFCell.LayoutConstants.CellHeight)
        return theLayout
    }
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        configureBindings()
        viewModel.fetchTrendingGIFList()
    }

    override func loadView() {
        view = UIView()
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        viewModel?.didFinishDisplayingList()
    }
}

// MARK: - RX Bindings
extension GIFListViewController {
    private func configureBindings() {
        cellForRowBinding(vm: viewModel)
        cellWasSelectedBinding(cv: collectionView)
    }
    
    private func cellForRowBinding(vm: GIFListViewModel) {
        vm.publisher.observe(on: MainScheduler.instance)
        .do(onError: { error in
            // handle by displaying an alert & a retry action
        }, onCompleted: {
        }).catchAndReturn([GIF]())
        .bind(to:
            collectionView.rx.items(cellIdentifier: GIFCell.identifier(), cellType: GIFCell.self)
        ) { row, gif, cell in
            cell.gif = gif
        }.disposed(by: disposeBag)
    }
    
    private func cellWasSelectedBinding(cv: UICollectionView) {
        collectionView.rx.modelSelected(GIF.self).subscribe( { [weak self] gifElement in
            
            if let gif = gifElement.element {
                self?.viewModel.displayDetails(for: gif)
            } else { fatalError("Unable to fetch a GIF object from element \(gifElement)") }
        }).disposed(by: disposeBag)
    }
}

// MARK: UISearchBarDelegate

extension GIFListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // decided not to implement this because it could use up a lot of resources without a real-time feedback & smooth UI integration (which is outside of the scope).
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            viewModel.fetchSearchSearch(with: searchText)
        }
    }   
}
