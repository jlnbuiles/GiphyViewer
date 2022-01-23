import UIKit
import RxSwift
import SnapKit

class GIFDetailsViewController: UIViewController {
    
    private enum Layouts {
        static let HorizonalLabelPadding = 15.0
        static let VerticalLabelPadding = 15.0
        static let TopImageViewPadding = 75.0
        static let LabelHeight = 40.0
    }
    
    // MARK: - Properties
    var gifStub: GIFStub
    private var disposeBag = DisposeBag()
    var viewModel: GIFDetailsViewModel!
    var gif: GIF? {
        didSet {
            if let theGif = gif {
                nameLabel.text = theGif.title
                sourceLabel.text = theGif.sourceTld
                ratingLabel.text = theGif.rating.humanReadable()
                let url = theGif.images.fixedHeight.url
                gifImageView.kf.setImage(with: url, placeholder: UIImage(named: Constants.Assets.PlaceHolderImgName))
            }
        }
    }
    
    var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15.0)
        return lbl
    }()
    var sourceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15.0)
        return lbl
    }()
    var ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15.0)
        return lbl
    }()
    
    var gifImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    // MARK: - Initializer
    init(stub: GIFStub) {
        self.gifStub = stub
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GIF info details"
        viewModel.fetchGIF(by: gifStub.id)
        configureBindings()
        configureViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.coordinator?.willDismissView()
    }
    
    // MARK: - View Configuration
    func configureViews() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(sourceLabel)
        view.addSubview(ratingLabel)
        view.addSubview(gifImageView)
    }
    
    func setupConstraints() {
        
        gifImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy((0.85))
            make.height.equalTo(gifImageView.snp.width).multipliedBy(0.65)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Layouts.TopImageViewPadding)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.height.equalTo(Layouts.LabelHeight)
            make.top.equalTo(gifImageView.snp.bottom).offset(Layouts.VerticalLabelPadding)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        sourceLabel.snp.makeConstraints{ make in
            make.height.equalTo(Layouts.LabelHeight)
            make.top.equalTo(nameLabel.snp.bottom).offset(Layouts.VerticalLabelPadding)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        ratingLabel.snp.makeConstraints{ make in
            make.height.equalTo(Layouts.LabelHeight)
            make.top.equalTo(sourceLabel.snp.bottom).offset(Layouts.VerticalLabelPadding)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
    }
}

extension GIFDetailsViewController {
    
    private func configureBindings() {
        viewModel.publisher.observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] gifResponse in
            self?.gif = gifResponse.data
        }, onError: { error in
            print("on error \(error)")
        }).disposed(by: disposeBag)
    }
}
