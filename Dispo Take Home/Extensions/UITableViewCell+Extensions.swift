//
//  UITableViewCell+Extensions.swift
//  MVVMTutorial
//
//  Created by Julian Builes on 1/8/22.
//

import UIKit

extension UICollectionViewCell {

    class func identifier() -> String {
        return String(describing: Self.self)
    }
}
