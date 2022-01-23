//
//  GIFCell.swift
//  Dispo Take Home
//
//  Created by Julian Builes on 1/19/22.
//

import UIKit
import SnapKit
import Kingfisher

/**
        The GIF Cell. Displays high-level details about a GIF.
    
    - Author: Julian Builes
*/
class GIFCell: UICollectionViewCell {
    
    // MARK: - Constants
    enum LayoutConstants {
        static let Padding = 10.0
        static let LabelHeight = 40.0
        static let CellHeight = 75.0
    }
    
    // MARK: - Properties
    var gif: GIF? {
        didSet {
            if let theGIF = gif {
                nameLabel.text = theGIF.title
                let url = theGIF.images.fixedHeight.url
                thumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: Constants.Assets.PlaceHolderImgName))
            }
        }
    }
    var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15.0)
        return lbl
    }()
    var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented and hence should not be called!")
    }
    
    // MARK: - View Configuration
    func configureViews() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(thumbnailImageView)
    }
    
    func setupConstraints() {
        
        // imageView
        thumbnailImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.height.equalTo(contentView.snp.height)
        }
        
        // nameLbl
        nameLabel.snp.makeConstraints { make in
            let widthOffset = LayoutConstants.CellHeight + (LayoutConstants.Padding * 2)
            make.width.equalToSuperview().offset(-widthOffset)
            make.height.equalTo(50)
            make.left.equalTo(thumbnailImageView.snp.right).offset(LayoutConstants.Padding)
            make.topMargin.equalToSuperview()
        }
    }
}
