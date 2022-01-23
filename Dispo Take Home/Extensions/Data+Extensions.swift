//
//  Data+Extensions.swift
//  MVVMTutorial
//
//  Created by Julian Builes on 1/8/22.
//

import Foundation

extension Data {
    
    func prettyJSONDict() -> NSDictionary? {
        return try? JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary ?? nil
    }
}
